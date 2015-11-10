'use strict';
require('tls'); // Compile events

console.log('Pre debugger');
debugger;
console.log('Post debugger');

setInterval(function() {
  console.log('Ping.');
}, 10000);
