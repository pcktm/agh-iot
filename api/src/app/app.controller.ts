import { controller, Get, HttpResponseOK, IAppController, Context, ApiInfo } from '@foal/core';
import { ApiController } from './controllers';
import { OpenApiController } from './controllers/openapi.controller';
import { RequireUser } from './hooks';

export class AppController implements IAppController {
  subControllers = [
    controller('/api', ApiController),
    controller('/docs', OpenApiController)
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
