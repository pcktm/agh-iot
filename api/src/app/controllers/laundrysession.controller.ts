import { ApiOperationSummary, Context, Delete, Get, HttpResponseBadRequest, HttpResponseConflict, HttpResponseCreated, HttpResponseNotFound, HttpResponseOK, Post, ValidateBody, ValidatePathParam } from '@foal/core';
import { Device, LaundrySession, User } from '../entities';
import { RequireUser } from '../hooks';
import {IsNull} from 'typeorm';

interface CreateLaundrySessionBody {
  deviceId: string;
  name: string;
  icon: string;
  color: string;
}

@RequireUser()
export class LaundrySessionController {

  @Get('/')
  @ApiOperationSummary('Get user\'s laundry sessions')
  async getLaundrySessions(ctx: Context<User>) {
    const laundrySessions = await LaundrySession.find({
      where: {
        user: {
          id: ctx.user.id
        }
      },
      order: {
        startedAt: 'DESC'
      },
      relations: ['device']
    });
    return new HttpResponseOK(laundrySessions);
  }

  @Get('/:id')
  @ApiOperationSummary('Get laundry session by id')
  @ValidatePathParam('id', { type: 'string', format: 'uuid' })
  async getLaundrySession(ctx: Context<User>) {
    const laundrySession = await LaundrySession.findOne({
      where: {
        id: ctx.request.params.id,
        user: {
          id: ctx.user.id
        },
      },
      relations: ['device']
    });
    if (!laundrySession) {
      return new HttpResponseNotFound();
    }
    return new HttpResponseOK(laundrySession);
  }

  @Get('/:id/measurements')
  @ApiOperationSummary('Get measurements for a laundry session')
  @ValidatePathParam('id', { type: 'string', format: 'uuid' })
  async getMeasurements(ctx: Context<User>) {
    const laundrySession = await LaundrySession.findOne({
      where: {
        id: ctx.request.params.id,
        user: {
          id: ctx.user.id
        }
      },
      relations: ['measurements'],
      order: {
        measurements: {
          createdAt: 'ASC'
        }
      }
    });
    if (!laundrySession) {
      return new HttpResponseNotFound();
    }
    return new HttpResponseOK(laundrySession.measurements);
  }

  @Post('/')
  @ApiOperationSummary('Create a new laundry session')
  @ValidateBody({
    properties: {
      deviceId: { type: 'string', format: 'uuid' },
      name: { type: 'string' },
      icon: { type: 'string' },
      color: { type: 'string' }
    },
    type: 'object',
    required: ['deviceId', 'name', 'icon', 'color'],
    additionalProperties: false
  })
  async createLaundrySession(ctx: Context<User>, params, body: CreateLaundrySessionBody) {
    const device = await Device.findOneBy({ id: body.deviceId });
    if (!device) {
      return new HttpResponseBadRequest();
    }
    // if there already is a session for this device
    const existingSession = await LaundrySession.findOne({
      where: {
        device: {
          id: device.id
        },
        finishedAt: IsNull(),
      }
    });
    if (existingSession) {
      return new HttpResponseConflict('There is already an active session for this device');
    }
    const laundrySession = new LaundrySession();
    laundrySession.user = ctx.user;
    laundrySession.name = body.name;
    laundrySession.icon = body.icon;
    laundrySession.color = body.color;
    laundrySession.device = device;
    await laundrySession.save();
    return new HttpResponseCreated(laundrySession);
  }

  @Post('/:id/end')
  @ApiOperationSummary('End a laundry session')
  @ValidatePathParam('id', { type: 'string', format: 'uuid' })
  async finishLaundrySession(ctx: Context<User>) {
    const session = await LaundrySession.findOne({
      where: {
        id: ctx.request.params.id,
        user: {
          id: ctx.user.id
        }
      }
    });

    if (!session) {
      return new HttpResponseNotFound();
    }

    session.finishedAt = new Date();
    await session.save();

    return new HttpResponseOK();
  }

  @Delete('/:id')
  @ApiOperationSummary('Delete a laundry session')
  @ValidatePathParam('id', { type: 'string', format: 'uuid' })
  async deleteLaundrySession(ctx: Context<User>) {
    const session = await LaundrySession.findOne({
      where: {
        id: ctx.request.params.id,
        user: {
          id: ctx.user.id
        }
      }
    });

    if (!session) {
      return new HttpResponseNotFound();
    }

    await session.remove();

    return new HttpResponseOK();
  }
}
