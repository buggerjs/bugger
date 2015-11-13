'use strict'; /* eslint no-console: 0 */
const request = require('request');

global.makeReq = function makeReq() {
  return request('https://pages.github.com/versions.json', {
    json: true,
  }, (err, res) => {
    console.log(err, res && res.body);
  });
};
