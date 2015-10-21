'use strict';

var AgentDebug = require('bindings')('AgentDebug');

AgentDebug.onMessage = function onMessage(message) {
  console.log('Parent got message', message);
}

AgentDebug.start();
debugger;

console.log('running');
setInterval(function() {
  console.log('Hitting a breakpoint');
  debugger;

  console.log('ping');
}, 2 * 1000);
