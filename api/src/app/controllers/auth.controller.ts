import { Context, HttpResponseConflict, HttpResponseOK, HttpResponseUnauthorized, Post, ValidateBody } from '@foal/core';
import * as argon2 from 'argon2';

import { getSecretOrPrivateKey } from '@foal/jwt';
import { sign } from 'jsonwebtoken';
import { User } from '../entities';

interface LoginBody {
  email: string;
  password: string;
}

interface SignupBody {
  name: string;
  email: string;
  password: string;
}

export class AuthController {

  @Post('/login')
  @ValidateBody({
    properties: {
      email: { type: 'string', format: 'email' },
      password: { type: 'string', minLength: 8 }
    },
    required: [ 'email', 'password' ],
    type: 'object',
  })
  async login(ctx: Context, params, body: LoginBody) {
    const { email, password } = body;
    const user = await User.findOne({where: {
      email
    }});

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
