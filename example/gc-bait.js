'use strict';
let curArr = [];
setInterval(() => {
  let arr = [];
  for (let idx = 1; idx < 1000; ++idx) {
    if (arr.length * 2 < arr.length * 5) {
      arr = arr.concat([
        `Track: ${idx}`.slice(1),
        new Array(idx).join('na'),
      ]);
    }
  }
  curArr = arr;
  if (typeof gc !== 'undefined') {
    /* global gc:true */
    gc();
  }
}, 300);

module.exports = function getCurArr() {
  return curArr;
};
