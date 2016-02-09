'use strict';

const vm = require('vm');

const Debug = vm.runInDebugContext('Debug');

let lastEval = undefined;
let ringBuffer = [];

const breakMap = new Map();

function addDebugBreak(target) {
  if (typeof target !== 'function') {
    throw new TypeError('debug(fn) expects a function');
  }
  if (breakMap.has(target)) {
    throw new Error('Function already has a breakpoint');
  }
  const breakId = Debug.setBreakPoint(target);
  breakMap.set(target, breakId);
}

function removeDebugBreak(target) {
  if (typeof target !== 'function') {
    throw new TypeError('debug(fn) expects a function');
  }
  const breakId = breakMap.get(target);
  if (!breakId) {
    throw new Error('Function has not breakpoint');
  }
  Debug.clearBreakPoint(breakId);
}

function createAPI() {
  /* eslint no-console:0 */
  const api = {
    $_: lastEval,

    debug: addDebugBreak,
    undebug: removeDebugBreak,

    profile: console.profile,
    profileEnd: console.profileEnd,

    dir: console.dir,
    dirxml: console.dirxml,
    table: console.table,

    keys(obj) { return Object.keys(obj); },
    values(obj) { return Object.keys(obj).map(key => obj[key]); },
  };

  [ 0, 1, 2, 3, 4 ].forEach(idx =>
    api[`$${idx}`] = ringBuffer[idx]);

  return api;
}

Object.defineProperty(global, '__buggerCLI', {
  configurable: false,
  writeable: false,
  get() {
    return createAPI();
  },
});

exports.addToRingBuffer = function addToRingBuffer(value) {
  ringBuffer.unshift(value);
  ringBuffer = ringBuffer.slice(0, 5);
  return value;
};

exports.setLastEval = function setLastEval(value) {
  lastEval = value;
  return value;
};
