'use strict'; /* eslint no-console:0 */

const cluster = require('cluster');
const http = require('http');

if (cluster.isMaster) {
  cluster.setupMaster();
  cluster.fork();
  cluster.fork();
  console.log('Master setup done');
} else {
  const server = http.createServer((req, res) => {
    res.end('ok');
  });
  server.listen(process.env.PORT || 3000, () => {
    console.log('Worker listening');
  });
}
