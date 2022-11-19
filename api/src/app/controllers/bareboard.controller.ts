import { ApiInfo, ApiOperationSummary, ApiServer, Context, Get, HttpResponseBadRequest, HttpResponseNotFound, HttpResponseOK, Post, ValidateBody } from '@foal/core';
import { Device, User } from '../entities';
import { RequireDevice } from '../hooks/RequireDevice';

interface DeviceRegistrationBody {
  ownerId: string;
}

@ApiInfo({
  title: 'Pranie Device API',
  description: 'Prywatne API tylko do obsługi requestów pochodzących z urządzeń',
  version: '1.0.0'
})
@ApiServer({
  url: '/bareboard'
})
@RequireDevice()
export class BareBoardController {

  @Get('/me')
  @ApiOperationSummary('Get current device info')
  getSelf(ctx: Context<Device>) {
    return new HttpResponseOK(ctx.user);
  }

  @Get('/owner')
  @ApiOperationSummary('Get this device\'s owner')
  async getOwner(ctx: Context<Device>) {
    const device = await Device.findOne({
      where: { id: ctx.user.id },
      relations: ['owner']
    })
    if (!device || !device.owner) {
      return new HttpResponseNotFound();
    }
    return new HttpResponseOK(device.owner);
  }

  @Post('/register')
  @ApiOperationSummary('Register this device to a user')
  @ValidateBody({
    properties: {
      ownerId: { type: 'string', format: 'uuid' }
    },
  })
  async registerDevice(ctx: Context<Device>, params, body: DeviceRegistrationBody) {
    const owner = await User.findOneBy({ id: body.ownerId });
    if (!owner) {
      return new HttpResponseBadRequest('No such user');
    }
    ctx.user.owner = owner;
    await ctx.user.save();
    return new HttpResponseOK();
  }

  @Post('/heartbeat')
  @ApiOperationSummary('Post a heartbeat')
  async postHeartbeat(ctx: Context<Device>) {
    ctx.user.lastSeenOnline = new Date();
    await ctx.user.save();
    return new HttpResponseOK();
  }
}
