import { controller, ApiInfo, ApiServer } from '@foal/core';
import { AuthController } from './auth.controller';
import { DeviceController } from './device.controller';
import { UserController } from './user.controller';
import { LaundrySessionController } from './laundrysession.controller';

@ApiInfo({
  title: 'Pranie API',
  description: 'Publiczne API do obsługi requestów z aplikacji, rejestracji i kont',
  version: '1.0.0'
})
@ApiServer({
  url: '/api'
})
export class ApiController {
  subControllers = [
    controller('/auth', AuthController),
    controller('/user', UserController),
    controller('/device', DeviceController),
    controller('/laundrysession', LaundrySessionController)
  ]

}
