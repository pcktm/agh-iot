import { SwaggerController } from '@foal/swagger';

import { ApiController } from './api.controller';
import { BareBoardController } from './bareboard.controller';

export class OpenApiController extends SwaggerController {
  options = [
    { name: 'public', controllerClass: ApiController, primary: true },
    { name: 'bareboard', controllerClass: BareBoardController }
  ];
}