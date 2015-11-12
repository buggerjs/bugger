'use strict';

const CORE_PATTERN = /^[\w-]+\.js$/;
const V8_PATTERN = /^native ([\w-]+\.js)$/;

function isNativeUrl(name) {
  return name.indexOf('native://') === 0;
}

function mapName(name) {
  if (isNativeUrl(name)) return name;

  if (CORE_PATTERN.test(name)) {
    return 'native://node/lib/' + name;
  }
  if (V8_PATTERN.test(name)) {
    return name.replace(V8_PATTERN, 'native://v8/$1');
  }
  return 'file://' + name.replace(/\\/g, '/');
}

function createUrlMapper() {
  const urlToName = {};
  const nameToUrl = {};

  function scriptUrlFromName(name) {
    if (!name) return undefined; // expected for eval "scripts"

    const mapped = mapName(name);
    nameToUrl[name] = mapped;
    urlToName[mapped] = name;
    return mapped;
  }

  function scriptNameFromUrl(url) {
    if (!url) return undefined; // expected for eval "scripts"

    if (urlToName.hasOwnProperty(url)) {
      return urlToName[url];
    }
    return url.replace(/^(file:\/\/|native:\/\/node\/lib\/)/, '');
  }

  return {
    scriptUrlFromName: scriptUrlFromName,
    scriptNameFromUrl: scriptNameFromUrl,
  };
}
module.exports = createUrlMapper();
