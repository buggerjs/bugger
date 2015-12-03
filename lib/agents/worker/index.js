'use strict';

const childProcess = require('child_process');
const events = require('events');
const fs = require('fs');

const _ = require('lodash');
const WebSocket = require('ws');

const BaseAgent = require('../base');

const CLI_PATH = require.resolve('../../cli.js');

const workerBus = new events.EventEmitter();

// Not using cluster.workers because that wouldn't call all forks
let lastWorkerId = 0;
const workers = Object.create(null);

class WorkerClient {
  constructor(id, url, worker, socketPath) {
    this.id = id;
    this.url = url;
    this.worker = worker;
    this.socketPath = socketPath;
    this._state = 'open';

    this.connected = false;
    setTimeout(() => this._createClient(), 1000);

    worker.on('disconnect', () => this._closed());
    worker.on('exit', () => this._closed());
  }

  _closed() {
    if (this._state !== 'open') return;

    if (this.connected) {
      try { this.client.close(); } catch (err) {
        /* eslint no-empty-block:0 */
      }
      this.connected = false;
    }
    workerBus.emit('workerTerminated', this);
    this._state = 'closed';
  }

  _createClient() {
    this.client = new WebSocket(`ws+unix://${this.socketPath}`);
    this.client.on('open', () => { this.connected = true; });
    this.client.on('message', (message) =>
      workerBus.emit('message', this.id, message));
  }

  sendMessage(message) {
    this.client.send(message);
  }
}

const original = childProcess.fork;
childProcess.fork = function fork(modulePath /* args, options*/) {
  // Get options and args arguments.
  let options;
  let args;
  if (Array.isArray(arguments[1])) {
    args = arguments[1];
    options = _.extend({}, arguments[2]);
  } else if (arguments[1] && typeof arguments[1] !== 'object') {
    throw new TypeError('Incorrect value of args option');
  } else {
    args = [];
    options = _.extend({}, arguments[1]);
  }
  const execArgv = options.execArgv = options.execArgv || process.execArgv;

  const workerId = String(++lastWorkerId);
  const socketPath = `/tmp/random-bugger-${workerId}.socket`;
  try {
    fs.unlinkSync(socketPath);
  } catch (err) {
    if (err.code !== 'ENOENT') {
      throw err;
    }
  }
  execArgv.push(CLI_PATH, `--port=${socketPath}`);

  const worker = original.call(this, modulePath, args, options);
  workers[workerId] = new WorkerClient(
    workerId, `file://${modulePath}`, worker, socketPath);
  workerBus.emit('workerCreated', worker);
  return worker;
};

class WorkerAgent extends BaseAgent {
  constructor() {
    super();

    workerBus.on('message', (workerId, message) =>
      this.emit('dispatchMessageFromWorker', { workerId, message }));

    workerBus.on('workerCreated', worker =>
      this.emit('workerCreated', {
        workerId: worker.id,
        url: worker.url,
        inspectorConnected: true,
      }));

    workerBus.on('workerTerminated', worker =>
      this.emit('workerTerminated', { workerId: worker.id }));
  }

  /**
   */
  enable() {
    for (const workerId of Object.keys(workers)) {
      this.emit('workerCreated', {
        workerId,
        url: workers[workerId].url,
        inspectorConnected: true,
      });
    }
  }

  /**
   */
  disable() {
    this._ignore('disable');
  }

  /**
   *
   * @param {string} workerId
   * @param {string} message
   */
  sendMessageToWorker(params) {
    // message is a devtools protocol message
    const worker = workers[params.workerId];
    worker.sendMessage(params.message);
  }

  /**
   *
   * @param {string} workerId
   */
  connectToWorker() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {string} workerId
   */
  disconnectFromWorker() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {boolean} value
   */
  setAutoconnectToWorkers(params) {
    this._ignore('setAutoconnectToWorkers', params);
  }
}

module.exports = WorkerAgent;
