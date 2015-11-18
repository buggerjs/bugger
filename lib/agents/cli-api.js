'use strict';

let lastEval = undefined;
let ringBuffer = [];

function createAPI() {
  const api = {
    $_: lastEval,
  };

  [ 0, 1, 2, 3, 4 ].forEach(idx =>
    api[`$${idx}`] = ringBuffer[idx]);

  return api;
}

Object.defineProperty(global, '__buggerCLI', {
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
