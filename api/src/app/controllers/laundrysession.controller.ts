import { Context, Get, HttpResponseOK } from '@foal/core';

export class LaundrySessionController {

  @Get('/')
  foo(ctx: Context) {
    return new HttpResponseOK();
  }

}
