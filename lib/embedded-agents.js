'use strict';

var createThread = require('./thread');
var Agents = require('./agents');

function startDebug(mainModule) {
  var thread = createThread(require.resolve('./io-thread'));
  var agents = new Agents(thread);

  require(mainModule);
  return agents;
}
module.exports = startDebug;
