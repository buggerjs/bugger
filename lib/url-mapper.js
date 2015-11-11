'use strict';

function createUrlMapper() {
  var urlToName = {};
  var nameToUrl = {};

  var CORE_PATTERN = /^[\w]+\.js$/;
  function scriptUrlFromName(name) {
    var mapped;
    if (name) {
      if (CORE_PATTERN.test(name)) {
        mapped = 'native://node/lib/' + name;
      } else if (name.indexOf('native://') === 0) {
        mapped = name;
      } else {
        mapped = 'file://' + name.replace(/\\/g, '/');
      }

      nameToUrl[name] = mapped;
      urlToName[mapped] = name;
    }
    // expected for eval "scripts"
    return mapped;
  }

  function scriptNameFromUrl(url) {
    if (!url) return;

    if (urlToName.hasOwnProperty(url)) {
      return urlToName[url];
    }
    return url.replace(/^(file:\/\/|native:\/\/node\/lib\/)/, '');
  }

  return {
    scriptUrlFromName: scriptUrlFromName,
    scriptNameFromUrl: scriptNameFromUrl
  };
};

module.exports = createUrlMapper();
