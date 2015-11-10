'use strict';

var http = require('http');
var EventEmitter = require('events').EventEmitter;

var WebSocketServer = require('ws').Server;
var debug = require('debug')('embedded-agents:io-thread');

thread.onMessage = function onMessage(message) {
  console.log('Ready to start listening to stuff!', thread);
};

thread.postMessage(new Buffer("Some data"));

// var Agents = require('../agents');

// var agents = new Agents();
// var debugEvents = new EventEmitter();

// embeddedAgents.onMessage =
// function onMessage(json) {
//   var data = JSON.parse(json);
//   if (data.type === 'event') {
//     debugEvents.emit(data.event, data.body);
//   } else {
//     console.error(json);
//   }
// };

// debugEvents.on('break', function(e) {
//   console.error('Execution stopped', e);
//   embeddedAgents.sendMessage('{"seq":1,"type":"request","command":"continue"}');
// });

// var server = http.createServer(function(req, res) {
//   console.error('[Devtools API] %s %s', req.method, req.url);
//   res.setHeader('Content-Type', 'application/json');
//   res.end('{}');
// });

// var wss = new WebSocketServer({
//   server: server
// });

// wss.on('connection', function(client) {
//   function writeJSON(obj) {
//     client.send(JSON.stringify(obj));
//   }

//   client.on('message', function(json) {
//     var message = JSON.parse(json);
//     var id = message.id;
//     agents.dispatch(message.method, message.params)
//       .then(
//         function(result) {
//           writeJSON({
//             id: id,
//             result: result,
//             error: null
//           });
//         },
//         function(error) {
//           if (error.message === 'Not implemented') {
//             debug('Not implemented', message.method);
//           }
//           writeJSON({
//             id: id,
//             result: null,
//             error: typeof error === 'string' ? error : error.message
//           });
//         }
//       );
//   });

//   // embeddedAgents.notifyReady();
// });

// var port = 8058;
// server.listen(port, function() {
//   // TODO: Delay until the first client connects - or not?
//   // embeddedAgents.notifyReady();
//   var devtoolsUrl =
//     'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
//   console.error(devtoolsUrl);
//   embeddedAgents.notifyReady();
// });
