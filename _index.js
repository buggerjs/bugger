'use strict';

console.log('_index.js', embeddedAgents);
embeddedAgents.onMessage = function(json) {
  console.log('Got message', JSON.parse(json));
};

setInterval(function() {
  console.log('pong');
}, 2 * 1000);
