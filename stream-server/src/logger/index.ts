import { default as pinoLogger} from "pino";

export function logger() {
  return pinoLogger({
    transport: {
      target: 'pino-pretty',
      options: {
        colorize: true
      }
    }
  });
}

// const logger = require('pino')()

