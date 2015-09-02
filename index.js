'use strict';

var AgentDebug = require('bindings')('AgentDebug');

AgentDebug.start();
debugger;

console.log('running');
setInterval(function() {
  console.log('Hitting a breakpoint');
  debugger;

  console.log('ping');
}, 2 * 1000);
