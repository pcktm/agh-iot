import { ApiOperationSummary, Context, Get, HttpResponseOK } from '@foal/core';
import { User } from '../entities';
import { RequireUser } from '../hooks';

@RequireUser()
export class UserController {

  @Get('/')
  @RequireUser()
  @ApiOperationSummary('Get the logged in user profile')
  getMe(ctx: Context<User>) {
    return new HttpResponseOK(ctx.user);
  }

  @Get('/devices')
  @ApiOperationSummary('Get the logged in user\'s devices')
  async getDevices(ctx: Context<User>) {
    const user = await User.findOne({
      where: { id: ctx.user.id },
      relations: ['devices']
    });
    if (!user) {
      return new HttpResponseOK([]);
    }
    return new HttpResponseOK(user.devices);
  }

}
