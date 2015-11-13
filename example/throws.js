'use strict';
global.messUp = function messUp() {
  process.nextTick(() => {
    const err = new TypeError('Invalid something');
    err.code = 'ESOMETHING';
    throw err;
  });
};
