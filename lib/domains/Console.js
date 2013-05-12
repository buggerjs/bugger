// Generated by CoffeeScript 2.0.0-beta5
var EventEmitter;
EventEmitter = require('events').EventEmitter;
module.exports = function (agentContext) {
  var Console;
  Console = new EventEmitter;
  Console.enable = function (param$, cb) {
    void 0;
  };
  Console.disable = function (param$, cb) {
    void 0;
  };
  Console.clearMessages = function (param$, cb) {
    void 0;
  };
  Console.setMonitoringXHREnabled = function (param$, cb) {
    var enabled;
    enabled = param$.enabled;
  };
  Console.addInspectedNode = function (param$, cb) {
    var nodeId;
    nodeId = param$.nodeId;
  };
  Console.addInspectedHeapObject = function (param$, cb) {
    var heapObjectId;
    heapObjectId = param$.heapObjectId;
  };
  Console.emit_messageAdded = function (params) {
    var notification;
    notification = {
      params: params,
      method: 'Console.messageAdded'
    };
    return this.emit('notification', notification);
  };
  Console.emit_messageRepeatCountUpdated = function (params) {
    var notification;
    notification = {
      params: params,
      method: 'Console.messageRepeatCountUpdated'
    };
    return this.emit('notification', notification);
  };
  Console.emit_messagesCleared = function (params) {
    var notification;
    notification = {
      params: params,
      method: 'Console.messagesCleared'
    };
    return this.emit('notification', notification);
  };
  Console.ConsoleMessage = {
    id: 'ConsoleMessage',
    type: 'object',
    description: 'Console message.',
    properties: [
      {
        name: 'source',
        type: 'string',
        'enum': [
          'xml',
          'javascript',
          'network',
          'console-api',
          'storage',
          'appcache',
          'rendering',
          'css',
          'security',
          'other'
        ],
        description: 'Message source.'
      },
      {
        name: 'level',
        type: 'string',
        'enum': [
          'log',
          'warning',
          'error',
          'debug'
        ],
        description: 'Message severity.'
      },
      {
        name: 'text',
        type: 'string',
        description: 'Message text.'
      },
      {
        name: 'type',
        type: 'string',
        optional: true,
        'enum': [
          'log',
          'dir',
          'dirxml',
          'table',
          'trace',
          'clear',
          'startGroup',
          'startGroupCollapsed',
          'endGroup',
          'assert',
          'timing',
          'profile',
          'profileEnd'
        ],
        description: 'Console message type.'
      },
      {
        name: 'url',
        type: 'string',
        optional: true,
        description: 'URL of the message origin.'
      },
      {
        name: 'line',
        type: 'integer',
        optional: true,
        description: 'Line number in the resource that generated this message.'
      },
      {
        name: 'column',
        type: 'integer',
        optional: true,
        description: 'Column number on the line in the resource that generated this message.'
      },
      {
        name: 'repeatCount',
        type: 'integer',
        optional: true,
        description: 'Repeat count for repeated messages.'
      },
      {
        name: 'parameters',
        type: 'array',
        items: { $ref: 'Runtime.RemoteObject' },
        optional: true,
        description: 'Message parameters in case of the formatted message.'
      },
      {
        name: 'stackTrace',
        $ref: 'StackTrace',
        optional: true,
        description: 'JavaScript stack trace for assertions and error messages.'
      },
      {
        name: 'networkRequestId',
        $ref: 'Network.RequestId',
        optional: true,
        description: 'Identifier of the network request associated with this message.'
      }
    ]
  };
  Console.CallFrame = {
    id: 'CallFrame',
    type: 'object',
    description: 'Stack entry for console errors and assertions.',
    properties: [
      {
        name: 'functionName',
        type: 'string',
        description: 'JavaScript function name.'
      },
      {
        name: 'url',
        type: 'string',
        description: 'JavaScript script name or url.'
      },
      {
        name: 'lineNumber',
        type: 'integer',
        description: 'JavaScript script line number.'
      },
      {
        name: 'columnNumber',
        type: 'integer',
        description: 'JavaScript script column number.'
      }
    ]
  };
  Console.StackTrace = {
    id: 'StackTrace',
    type: 'array',
    items: { $ref: 'CallFrame' },
    description: 'Call frames for assertions or error messages.'
  };
  return Console;
};