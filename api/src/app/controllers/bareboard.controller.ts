import { ApiInfo, ApiOperationSummary, ApiServer, Context, Get, HttpResponseBadRequest, HttpResponseCreated, HttpResponseNotFound, HttpResponseOK, Post, ValidateBody } from '@foal/core';
import { IsNull } from 'typeorm';
import { Device, User, LaundrySession, Measurement } from '../entities';
import { RequireDevice } from '../hooks/RequireDevice';

interface DeviceRegistrationBody {
  ownerId: string;
}

interface MeasurementBody {
  temperature: number;
  humidity: number;
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

  @Post('/measurement')
  @ApiOperationSummary('Post a measurement if this device is in an active laundry session')
  @ValidateBody({
    properties: {
      temperature: { type: 'number' },
      humidity: { type: 'number' }
    },
    type: 'object',
    required: ['temperature', 'humidity'],
    additionalProperties: false
  })
  async postMeasurement(ctx: Context<Device>, params, body: MeasurementBody) {

    const laundrySession = await LaundrySession.findOne({
      where: { device: {
        id: ctx.user.id
      }, finishedAt: IsNull() }
    });
    if (!laundrySession) {
      return new HttpResponseOK('No active laundry session');
    }

    const measurement = new Measurement();
    measurement.laundrySession = laundrySession;
    measurement.temperature = ctx.request.body.temperature;
    measurement.humidity = ctx.request.body.humidity;
    measurement.createdAt = new Date();
    await measurement.save();

    return new HttpResponseCreated(measurement);
  }
}
