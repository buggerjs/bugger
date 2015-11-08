#!/usr/bin/env node
'use strict';

function toValue(type, text) {
  switch (type) {
  case 'bool':
    return text === 'true';

  case 'int':
    return parseInt(text, 10);

  case 'float':
    return Number(text);

  case 'string':
    return text;

  case 'maybe_bool':
    if (text === 'unset') {
      return undefined;
    } else {
      return text === 'true';
    }

  default:
    throw new Error('Could not parse ' + type + ': ' + JSON.stringify(text));
  }
}

function parseFlags(out) {
  const OPTIONS = /  --(\w+) (?:\(([^\n]+)\))?\n[ ]+type: (\w+)[ ]+default: ([^\n]+)\n/g;

  const flags = [];
  let match;
  while (match = OPTIONS.exec(out)) {
    const name = match[1];
    const comment = match[2];
    const type = match[3];
    const def = match[4];
    if (name !== 'help') {
      flags.push({ name, comment, type, default: toValue(type, def) });
    }
  }

  const boolean = flags
    .filter(flag => flag.type === 'bool')
    .map(flag => flag.name);

  const names = flags.map(flag => flag.name);

  return { boolean, names, flags };
}

const chunks = [];
process.stdin
  .on('data', function(chunk) {
    chunks.push(chunk);
  })
  .on('end', function() {
    console.log('%j', parseFlags(chunks.join('')));
  });
