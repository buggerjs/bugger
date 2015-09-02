'use strict';

var http = require('http');

var ws = require('ws');

embeddedAgents.onDebugEvent =
function onDebugEvent(json) {
  var event = JSON.parse(json);
  switch (event.event) {
    case 'break':
      console.log('Execution stopped', event.body);
      break;

    default:
      console.log('Got debug event', evnet);
  }
};

var server = http.createServer(function(req, res) {
  console.log('[Devtools API] %s %s', req.method, req.url);
  res.setHeader('Content-Type', 'application/json');
  res.end('{}');
});

server.listen(8058, function() {
  embeddedAgents.notifyReady();
});
