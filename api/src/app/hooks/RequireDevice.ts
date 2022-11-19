import { HookDecorator } from '@foal/core';
import { JWTRequired } from '@foal/jwt';
import { Device } from '../entities';

export function RequireDevice(): HookDecorator {
  return JWTRequired({
    userIdType: 'string',
    user: async (sub: string, services) => {
      const user = await Device.findOneByOrFail({ id: sub });
      return user;
    }
  })
}
