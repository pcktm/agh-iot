import { ApiOperationSummary, ApiResponse, Context, dependency, HttpResponseConflict, HttpResponseOK, HttpResponseUnauthorized, IApiResponse, Post, ValidateBody } from '@foal/core';
import * as argon2 from 'argon2';

import { getSecretOrPrivateKey } from '@foal/jwt';
import { sign } from 'jsonwebtoken';
import { User } from '../entities';
import { LoggerService } from '../services';

interface LoginBody {
  email: string;
  password: string;
}

interface SignupBody {
  name: string;
  email: string;
  password: string;
}

const tokenResponseContent: IApiResponse = {
  description: 'Success',
  content: {
    'application/json': {
      schema: {
        type: 'object',
        properties: {
          token: { type: 'string' }
        }
      }
    }
  }
}

export class AuthController {
  @dependency
  logger: LoggerService;

  @Post('/login')
  @ValidateBody({
    properties: {
      email: { type: 'string', format: 'email' },
      password: { type: 'string', minLength: 8 }
    },
    required: [ 'email', 'password' ],
    type: 'object',
  })
  @ApiOperationSummary('Log in and get a JWT token')
  @ApiResponse(200, tokenResponseContent)
  @ApiResponse(401, {description: 'Unauthorized, invalid password or no such user'})
  async login(ctx: Context, params, body: LoginBody) {
    const { email, password } = body;
    const user = await User.findOne({
      where: {email},
      select: ['id', 'passwordHash']
    });

    if (!user) {
      return new HttpResponseUnauthorized();
    }
    
    const valid = await argon2.verify(user.passwordHash, password);
    if (!valid) {
      return new HttpResponseUnauthorized();
    }

    const token = sign({ sub: user.id }, getSecretOrPrivateKey(), { expiresIn: '1y' });

    return new HttpResponseOK({ token });
  }

  @Post('/signup')
  @ValidateBody({
    properties: {
      email: { type: 'string', format: 'email' },
      name: { type: 'string', minLength: 1 },
      password: { type: 'string', minLength: 8 }
    },
    required: [ 'email', 'name', 'password' ],
    type: 'object',
  })
  @ApiOperationSummary('Sign up and get a JWT token')
  @ApiResponse(200, tokenResponseContent)
  @ApiResponse(409, {
    description: 'Conflict, user already exists',
  })
  async signup(ctx: Context, params, body: SignupBody) {
    const { email, name, password } = body;
    const user = await User.findOne({where: {
      email
    }})
    if (user) {
      return new HttpResponseConflict();
    }

    const passwordHash = await argon2.hash(password);
    const newUser = await User.create({
      email,
      name,
      passwordHash
    }).save();

    const token = sign({ sub: newUser.id }, getSecretOrPrivateKey(), { expiresIn: '1y' });

    return new HttpResponseOK({ token });
  }
}
