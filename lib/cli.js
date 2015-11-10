'use strict';

var path = require('path');
var vm = require('vm');

var debug = require('debug')('embedded-agents:cli');

var createThread = require('./thread');

var Debug = vm.runInDebugContext('Debug');

function createEmbeddedAgents(thread) {
  var embeddedAgents = {};
  var paused = false;

  function onAgentMessage(message) {
    console.log('Proxy got: %s', message);
  }
  thread.on('message', onAgentMessage);
  thread.postMessage(new Buffer('foo'));

  embeddedAgents.onBreak = function onBreak(state, event) {
    console.log('onBreak', { state, event });
    paused = true;
    var message;
    while (paused && !!(message = thread.poll())) {
      onAgentMessage(message);
    }
    console.log('message', message);
    paused = false;
  };

  embeddedAgents.onDebugEvent = onDebugEvent;

  return embeddedAgents;
}

var Lookup = [ 'Invalid' ].concat(Object.keys(Debug.DebugEvent));
function onDebugEvent(type, state, event, agents) {
  var handlerName = `on${Lookup[type]}`;
  var handler = agents[handlerName];
  if (typeof handler === 'function') {
    handler(state, event);
  } else {
    debug('Missing handler', handlerName);
  }
}

var thread = createThread(require.resolve('./io-thread'));
var agents = createEmbeddedAgents(thread);
Debug.setListener(onDebugEvent, agents);

var mainModule = path.resolve(process.cwd(), process.argv[2]);
require(mainModule);
