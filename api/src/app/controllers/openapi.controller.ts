import { SwaggerController } from '@foal/swagger';

import { ApiController } from './api.controller';
import { DeviceController } from './device.controller';

export class OpenApiController extends SwaggerController {
  options = [
    { name: 'public', controllerClass: ApiController, primary: true },
    { name: 'device', controllerClass: DeviceController }
  ];
}