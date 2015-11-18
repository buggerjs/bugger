'use strict';

const util = require('util');

const _ = require('lodash');

const UrlMapper = require('../../url-mapper');

const BaseAgent = require('../base');
const ObjectGroup = require('../object-group');

function addToConsoleGroup(object) {
  return ObjectGroup.add('console', object);
}

function _wrap(agent, level, type, original) {
  if (original && '__original' in original) {
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
        source: 'javascript',
        level: level,
        text: text,
        type: type,
        url: url, line: line, column: column,
        parameters: _.map(arguments, addToConsoleGroup),
        stackTrace: trace,
      },
    });
    if (typeof original === 'function') {
      return original.apply(console, arguments);
    }
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
    console.dir = _wrap(this, 'log', 'dir', console.dir);
    console.dirxml = _wrap(this, 'log', 'dirxml', console.dirxml);
    console.error = _wrap(this, 'error', 'log', console.error);
    console.info = _wrap(this, 'info', 'log', console.info);
    console.log = _wrap(this, 'log', 'log', console.log);
    console.table = _wrap(this, 'log', 'table', console.table);
    console.trace = _wrap(this, 'log', 'trace', console.trace);
    console.warn = _wrap(this, 'warning', 'log', console.warn);
  }

  /**
   * Disables console domain, prevents further console messages from being reported to the client.
   */
  disable() {
    _unwrap(console, 'dir');
    _unwrap(console, 'dirxml');
    _unwrap(console, 'error');
    _unwrap(console, 'info');
    _unwrap(console, 'log');
    _unwrap(console, 'table');
    _unwrap(console, 'trace');
    _unwrap(console, 'warn');
  }

  /**
   * Clears console messages collected in the browser.
   */
  clearMessages() {
  }
}

module.exports = new ConsoleAgent();
