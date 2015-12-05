'use strict'; /* eslint no-console:0 */

const crypto = require('crypto');
const fs = require('fs');
const http = require('http');

const express = require('express');
const _ = require('lodash');
const request = require('request');

const port = 3000;
const baseUrl = `http://127.0.0.1:${port}`;

const INVALID_URI = 'http://10.255.255.1';

const app = express();

app.get('/hello', (req, res) => {
  res.json({ message: 'Hello World!' });
});

app.get('/big', (req, res) => {
  const blob = new Buffer(128 + ((Math.random() * 4096) | 0)).fill('x').toString();
  res.json({ blob, message: `Returned ${blob.length} bytes` });
});

app.get('/fail', (req) => {
  req.socket.destroy();
});

app.get('/silly-io', (req, res, next) => {
  let error;
  try {
    require('./throws');
  } catch (e) {
    error = e;
  }
  if (error) {
    return next(error);
  }
  res.json({ message: 'Well, this is unexpected...' });
});

app.get('/delays', (req, res, next) => {
  const hash = crypto.createHash('sha1');

  function sendChecksum(sha) {
    res.json({ filename: __filename, message: sha });
  }

  function loadOtherFile() {
    const readStream = fs.createReadStream('package.json');
    readStream.on('error', next);
    readStream.on('data', chunk => hash.update(chunk));
    readStream.on('end', () =>
      setImmediate(sendChecksum, hash.digest('hex')));
  }

  function loadFile() {
    const readStream = fs.createReadStream(__filename);
    readStream.on('error', next);
    readStream.on('data', chunk => hash.update(chunk));
    readStream.on('end', () => process.nextTick(loadOtherFile));
  }

  setTimeout(loadFile, Math.random() * 50 | 0);
});

app.get('/fib', (req, res) => {
  function terribleFib(x) {
    // Worst fib possible. We are trying to be awful.
    if (x < 2) return 1;
    return terribleFib(x - 2) + terribleFib(x - 1);
  }
  const n = 10 + Math.floor(Math.random() * 29); // max 38
  const start = process.hrtime();
  const fib = terribleFib(n);
  const dur = process.hrtime(start);

  function formatDur(pair) {
    return pair[0] * 1e3 + pair[1] / 1e6;
  }
  res.json({
    n, 'fib(n)': fib, dur,
    message: `fib(${n}) = ${fib} [ took ${formatDur(dur)}ms ]`,
  });
});

app.use((req, res) => {
  res.statusCode = 404;
  res.json({ message: 'Not found', url: req.url });
});

app.use((error, req, res, next) => {
  /* eslint no-unused-vars:0 */
  res.statusCode = 500;
  res.json({ message: error.message });
});

function runRequestor() {
  const pathname = _.sample([
    null,
    '/hello',
    '/big',
    '/silly-io',
    '/fail',
    '/delays',
    '/fib',
  ]);
  const uri = pathname === null ? INVALID_URI : baseUrl + pathname;
  request(uri, { json: true, timeout: 1000 }, (err, response) => {
    // console.log(err, response && response.body && response.body.message);
    // Start the next request sometime in the next second.
    setTimeout(runRequestor, Math.random() * 1000);
  });
}

const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server listening on ${baseUrl}`);

  for (let i = 0; i < 40; ++i) {
    setTimeout(runRequestor, i * 50);
  }
});
