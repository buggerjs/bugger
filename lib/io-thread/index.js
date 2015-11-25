/* global thread */
'use strict';

const http = require('http');
const EventEmitter = require('events').EventEmitter;

const debug = require('debug')('bugger:io-thread');
const WebSocketServer = require('ws').Server;

const port = process.argv[2];

const threadEvents = new EventEmitter();
thread.onMessage = function onMessage(message) {
  threadEvents.emit('message', message);
};

const pageId = '961C1EB7-A0DA-2F42-F6D4-76B453E70DB5';
// var devtoolsBase = 'chrome-devtools://devtools/bundled/inspector.html';
const devtoolsBase =
  'https://chrome-devtools-frontend.appspot.com/serve_rev/@202665/inspector.html';
const ws = '127.0.0.1:' + port + '/devtools/page/' + pageId;

const page = {
  description: '',
  devtoolsFrontendUrl: devtoolsBase + '?ws=' + ws,
  faviconUrl: 'https://nodejs.org/favicon.ico',
  id: pageId,
  title: process.title,
  type: 'page',
  url: 'file://' + process.mainModule.filename,
  webSocketDebuggerUrl: 'ws://' + ws,
};

const server = http.createServer((req, res) => {
  debug('[bugger-agents] %s %s', req.method, req.url);
  res.setHeader('Content-Type', 'application/json');
  if (req.url === '/json/version') {
    return res.end(JSON.stringify({
      Browser: 'Node/' + process.version.substr(1),
      'Protocol-Version': '1.1',
      'User-Agent': 'Node/' + process.version + ' v8' + process.versions.v8,
      'WebKit-Version': '537.36 (@181352)',
    }, null, 2));
  } else if (req.url === '/json' || req.url === '/json/list') {
    return res.end(JSON.stringify([ page ], null, 2));
  } else if (req.url === '/json/activate/' + pageId) {
    return res.end('"Target activated"');
  }
  res.end('{}');
});

const wss = new WebSocketServer({ server: server });

wss.on('connection', client => {
  function accept(json) {
    thread.postMessage(new Buffer(json));
  }

  function dispatch(message) {
    client.send('' + message);
  }

  function setup() {
    client.on('message', accept);
    threadEvents.on('message', dispatch);
  }

  function cleanup() {
    client.removeListener('message', accept);
    threadEvents.removeListener('message', dispatch);
  }

  setup();
  client.on('close', cleanup);
});

server.listen(port, () => {
  const devtoolsUrl =
    'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
  process.stderr.write(`${devtoolsUrl}\n`);
});
