import { controller, Get, HttpResponseOK, IAppController, Context } from '@foal/core';
import { ApiController, BareBoardController } from './controllers';
import { OpenApiController } from './controllers/openapi.controller';
import { RequireUser } from './hooks';

export class AppController implements IAppController {
  subControllers = [
    controller('/api', ApiController),
    controller('/bareboard', BareBoardController),
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
