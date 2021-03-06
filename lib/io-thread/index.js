/* global thread */
'use strict';

const http = require('http');
const EventEmitter = require('events').EventEmitter;

const debug = require('debug')('bugger:io-thread');
const uuid = require('node-uuid');
const WebSocketServer = require('ws').Server;

const port = process.argv[2];
const filename = process.argv[3];

const threadEvents = new EventEmitter();
thread.onMessage = function onMessage(message) {
  threadEvents.emit('message', message);
};

const pageId = uuid.v1().toUpperCase();
const devtoolsBase =
  'https://chrome-devtools-frontend.appspot.com/serve_rev/@202665/inspector.html';
const ws = '127.0.0.1:' + port + '/devtools/page/' + pageId;

const page = {
  description: '',
  devtoolsFrontendUrl: devtoolsBase + '?ws=' + ws,
  faviconUrl: 'https://nodejs.org/favicon.ico',
  id: pageId,
  title: 'node [' + process.pid + ']',
  type: 'page',
  url: 'file://' + filename,
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

let lastConnectionId = 0;

wss.on('connection', client => {
  const connectionId = ++lastConnectionId;
  const connectionPrefix = connectionId + ':';
  const prefixLength = connectionPrefix.length;

  thread.postMessage(new Buffer(connectionPrefix + 'true'));

  function acceptFromClient(json) {
    thread.postMessage(new Buffer(connectionPrefix + json));
  }

  function dispatchToClient(messageBuffer) {
    const message = '' + messageBuffer;
    if (message.slice(0, prefixLength) !== connectionPrefix) {
      return;
    }
    client.send(message.slice(prefixLength));
  }

  function setup() {
    client.on('message', acceptFromClient);
    threadEvents.on('message', dispatchToClient);
  }

  function cleanup() {
    thread.postMessage(new Buffer(connectionPrefix + 'false'));
    client.removeListener('message', acceptFromClient);
    threadEvents.removeListener('message', dispatchToClient);
  }

  setup();
  client.on('close', cleanup);
});

server.listen(port, () => {
  const devtoolsUrl =
    'chrome-devtools://devtools/bundled/inspector.html?ws=' + ws;
  process.stderr.write(`${devtoolsUrl}\n`);
});
