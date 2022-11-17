// App
import { User } from '../app/entities';
import { dataSource } from '../db';
import * as argon2 from 'argon2';

export const schema = {
  additionalProperties: false,
  properties: {

  },
  required: [

  ],
  type: 'object',
};

export async function main() {
  await dataSource.initialize();

  try {
    const user = new User();
    user.name = 'John Doe';
    user.email = 'john@example.com';
    user.passwordHash = await argon2.hash('password');

    console.log(await user.save());
  } catch (error: any) {
    console.error(error.message);
  } finally {
    await dataSource.destroy();
  }
}
