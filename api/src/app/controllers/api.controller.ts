import { Context, Get, HttpResponseOK, controller, ApiInfo } from '@foal/core';
import { RequireUser } from '../hooks';
import { AuthController } from './auth.controller';

@ApiInfo({
  title: 'Pranie API',
  version: '1.0.0'
})
export class ApiController {
  subControllers = [
    controller('/auth', AuthController),
  ]

  @Get('/me')
  @RequireUser()
  getMe(ctx: Context) {
    return new HttpResponseOK(ctx.user);
  }

}
