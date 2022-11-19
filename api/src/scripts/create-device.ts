import { Device } from '../app/entities';
import { dataSource } from '../db';

import { getSecretOrPrivateKey } from '@foal/jwt';
import { sign } from 'jsonwebtoken';

export const schema = {
  additionalProperties: false,
  properties: {

  },
  required: [

  ],
  type: 'object',
};

export async function main(args: any) {
  await dataSource.initialize();

  try {
    const device = new Device();
    device.name = 'Test Device';
    await device.save();
    console.log('Device created with id:', device.id);
    const token = sign({ sub: device.id }, getSecretOrPrivateKey(), { issuer: 'manufacturer' });
    console.log('Manufacturer device token:', token);
  } catch(e) {
    console.error(e);
  } finally {
    await dataSource.destroy();
  }
}
