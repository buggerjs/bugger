'use strict';

const events = require('events');

const debug = require('debug')('embedded-agents:base');

const __emit = events.EventEmitter.prototype.emit;

class BaseAgent extends events.EventEmitter {
  emit(name, data) {
    return __emit.call(this, '_event', name, data);
  }

  _ignore(name, params) {
    debug('Ignore: %s.%s', this.constructor.name, name, params);
  }
}
module.exports = BaseAgent;
