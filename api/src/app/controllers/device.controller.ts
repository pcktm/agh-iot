import { ApiOperationSummary, Context, Get, HttpResponseNotFound, HttpResponseOK, HttpResponseUnauthorized, ValidatePathParam } from '@foal/core';
import { Device, User } from '../entities';
import { RequireUser } from '../hooks';

@RequireUser()
export class DeviceController {

  @Get('/:deviceId')
  @ApiOperationSummary('Get the device by id')
  @ValidatePathParam('deviceId', { type: 'string', format: 'uuid' })
  async getDeviceById(ctx: Context<User>) {
    const device = await Device.findOne({
      where: { id: ctx.request.params.deviceId },
      relations: ['owner']
    })
    if (!device) {
      return new HttpResponseNotFound();
    }
    
    if (device.owner.id !== ctx.user.id) {
      return new HttpResponseUnauthorized();
    }
    return new HttpResponseOK(device);
  }

}
