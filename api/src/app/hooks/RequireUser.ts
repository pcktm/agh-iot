import { HookDecorator } from '@foal/core';
import { JWTRequired } from '@foal/jwt';
import { User } from '../entities';

export function RequireUser(): HookDecorator {
  return JWTRequired({
    userIdType: 'string',
    user: async (sub: string, services) => {
      const user = await User.findOneByOrFail({ id: sub });
      return user;
    }
  })
}
