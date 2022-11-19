import { ApiInfo, ApiOperationSummary, ApiServer, Context, Get, HttpResponseOK, Post } from '@foal/core';
import { RequireDevice } from '../hooks/RequireDevice';

@ApiInfo({
  title: 'Pranie Device API',
  description: 'Prywatne API tylko do obsługi requestów pochodzących z urządzeń',
  version: '1.0.0'
})
@ApiServer({
  url: '/device'
})
@RequireDevice()
export class DeviceController {

  @Get('/me')
  @ApiOperationSummary('Get current device info')
  getSelf(ctx: Context) {
    return new HttpResponseOK(ctx.user);
  }

  @Get('/owner')
  @ApiOperationSummary('Get this device\'s owner')
  getStatus(ctx: Context) {
    return new HttpResponseOK();
  }

  @Post('/heartbeat')
  @ApiOperationSummary('Post a heartbeat')
  postHeartbeat(ctx: Context) {
    return new HttpResponseOK();
  }
}
