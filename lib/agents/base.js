'use strict';

const debug = require('debug')('embedded-agents:base');

class BaseAgent {
  _ignore(name, params) {
    debug('Ignore: %s.%s', this.constructor.name, name, params);
  }

  _forward(name, params) {
    throw new Error('Should be forwarded');
  }
}
module.exports = BaseAgent;
