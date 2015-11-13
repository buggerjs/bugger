'use strict'; /* eslint no-console: 0 */
global.messUp = function messUp() {
  process.nextTick(() => {
    const err = new TypeError('Invalid something');
    err.code = 'ESOMETHING';
    try {
      throw err;
    } catch (noErr) {
      console.error('noErr', noErr);
    }
  });
};
