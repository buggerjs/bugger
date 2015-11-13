'use strict';

const util = require('util');

const _ = require('lodash');

const UrlMapper = require('../../url-mapper');

const BaseAgent = require('../base');
const ObjectGroup = require('../object-group');

function addToConsoleGroup(object) {
  return ObjectGroup.add('console', object);
}

function _wrap(agent, level, original) {
  if (original.__original) {
    return original;
  }

  function writeLog() {
    const text = util.format.apply(null, arguments);
    const trace = UrlMapper.makeStackTrace(writeLog);

    let url;
    let column;
    let line;
    if (trace.length > 0 && trace[0].url) {
      url = trace[0].url;
      line = trace[0].lineNumber;
      column = trace[0].columnNumber;
    }

    agent.emit('messageAdded', {
      message: {
        level: level,
        source: 'javascript',
        text: text,
        parameters: _.map(arguments, addToConsoleGroup),
        stackTrace: trace,
        url: url, line: line, column: column,
      },
    });
    return original.apply(console, arguments);
  }
  writeLog.__original = original;
  return writeLog;
}

function _unwrap(obj, field) {
  const current = obj[field];
  if (typeof current === 'function' && typeof current.__original === 'function') {
    obj[field] = current.__original;
  }
}

class ConsoleAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
   */
  enable() {
    /* eslint no-console: 0 */
    console.log = _wrap(this, 'log', console.log);
    console.info = _wrap(this, 'log', console.info);
    console.warn = _wrap(this, 'warning', console.warn);
    console.error = _wrap(this, 'error', console.error);
  }

  /**
   * Disables console domain, prevents further console messages from being reported to the client.
   */
  disable() {
    _unwrap(console, 'log');
    _unwrap(console, 'info');
    _unwrap(console, 'warn');
    _unwrap(console, 'error');
  }

  /**
   * Clears console messages collected in the browser.
   */
  clearMessages() {
  }
}

module.exports = ConsoleAgent;
