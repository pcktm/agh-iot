import { controller, Get, HttpResponseOK, IAppController, Context } from '@foal/core';
import { AuthController } from './controllers';
import { RequireUser } from './hooks';

export class AppController implements IAppController {
  subControllers = [
    controller('/auth', AuthController),
  ];

  @Get('/')
  index() {
    return new HttpResponseOK('Hello world!');
  }

  @Get('/me')
  @RequireUser()
  getMe(ctx: Context) {
    return new HttpResponseOK(ctx.user);
  }
}
