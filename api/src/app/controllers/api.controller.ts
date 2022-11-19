import { Context, Get, HttpResponseOK, controller, ApiInfo, ApiOperationSummary, ApiServer } from '@foal/core';
import { RequireUser } from '../hooks';
import { AuthController } from './auth.controller';

@ApiInfo({
  title: 'Pranie API',
  description: 'Publiczne API do obsługi requestów z aplikacji, rejestracji i kont',
  version: '1.0.0'
})
@ApiServer({
  url: '/api'
})
export class ApiController {
  subControllers = [
    controller('/auth', AuthController),
  ]

  @Get('/me')
  @RequireUser()
  @ApiOperationSummary('Get the logged in user profile')
  getMe(ctx: Context) {
    return new HttpResponseOK(ctx.user);
  }

}
