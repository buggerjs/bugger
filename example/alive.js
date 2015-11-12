'use strict'; /* eslint no-console: 0 */
setInterval(() => {
  let myVar = 100;
  myVar = myVar + 30;
  console.log('Ping:', myVar * 2);
}, 2 * 1000);
