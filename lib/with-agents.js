'use strict';

var _ = require('lodash');

var TargetProcess = require('bugger-agents/lib/target-process');
var BuggerAgents = require('bugger-agents');
var attachToPort = BuggerAgents.attachToPort;

function withAgents(filename, args, debugBreak) {
  var target = TargetProcess.fork(filename, args, {
    debugBreak: debugBreak,
    silent: !process.env.BUGGER_PIPE_CHILD
  });

  process.on('exit', function() {
    try { target.kill(); } catch (e) {}
  });

  return attachToPort(target.debugPort, target);
}

module.exports = withAgents;
