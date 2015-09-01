'use strict';
var vm = require('vm');

var Debug = vm.runInDebugContext('Debug');

var AgentDebug = require('bindings')('AgentDebug');
// var AgentDebug = require('/Users/jankrems/Library/Developer/Xcode/DerivedData/binding-hlcwduqbnqjizudbagjurcpuprsk/Build/Products/Debug/AgentDebug.node');

AgentDebug.start();
debugger;

console.log('running');
setInterval(function() {
  console.log('Hitting a breakpoint');
  debugger;

  console.log('ping');
}, 2 * 1000);
