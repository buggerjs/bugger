'use strict';

var _ = require('lodash');

var TargetProcess = require('bugger-agents/lib/target-process');
var BuggerAgents = require('bugger-agents');
var attachToPort = BuggerAgents.attachToPort;

function withAgents(filename, args, options) {
  var target = TargetProcess.fork(filename, args, _.extend({
    silent: !process.env.BUGGER_PIPE_CHILD,
  }, options));

  process.on('exit', function() {
    try { target.kill(); } catch (e) {}
  });

  return attachToPort(target.debugPort, target);
}

module.exports = withAgents;
