import pino, {Logger as TLogger} from 'pino';

export class LoggerService {
  private logger: TLogger;

  constructor() {
    this.logger = pino();
  }

  info(msg: string, ...data: any[]) {
    this.logger.info(msg, ...data);
  }

  warn(msg: string, ...data: any[]) {
    this.logger.warn(msg, ...data);
  }

  error(msg: string, ...data: any[]) {
    this.logger.error(msg, ...data);
  }
}
