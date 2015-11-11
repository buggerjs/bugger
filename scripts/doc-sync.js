#!/usr/bin/env node
'use strict';

const path = require('path');
const fs = require('fs');

const _ = require('lodash');

const protocol = require(
  '../../blink/Source/devtools/protocol.json');

const agentsDirectory = path.join(__dirname, '..', 'lib', 'agents');
function getAgentFilename(domainName) {
  return path.join(agentsDirectory, _.kebabCase(domainName) + '/index.js');
}

function commentLines(str) {
  return str.replace(/\. /g, '.\n   * ');
}

function formatType(obj) {
  const optMarker = obj.optional ? '=' : '';
  let typename = obj.$ref || obj.type;
  if (typename === 'array') {
    typename = 'Array.<' + formatType(obj.items) + '>';
  } else if (typename === 'object') {
    if (Array.isArray(obj.properties)) {
      typename = '{' + obj.properties.map(prop => {
        return prop.name + ': ' + formatType(prop);
      }).join(', ') + '}';
    } else {
      typename = 'Object';
    }
  }

  if (obj.enum) {
    typename += ' ' + obj.enum.join('|');
  }

  return typename + optMarker;
}

function removeTrailingSpaces(string) {
  return string.replace(/\s+\n/g, '\n');
}

function formatCommand(command) {
  function formatParameters(parameters) {
    if (!Array.isArray(parameters)) return '';
    return '   * \n   * ' + parameters.map(param => {
      return '@param {' + formatType(param) + '} ' +
        param.name + (param.description ? (' ' + param.description) : '');
    }).join('\n   * ') + '\n';
  }

  function formatReturns(returns) {
    if (!Array.isArray(returns)) return '';
    return '   * \n   * ' + returns.map(ret => {
      return '@returns {' + formatType(ret) + '} ' +
        ret.name + (ret.description ? (' ' + ret.description) : '');
    }).join('\n   * ') + '\n';
  }

  function formatThrows(error) {
    if (!error) return '';
    return '   * \n   * @throws {' + formatType(error) + '} \n';
  }

  function formatDescription(description) {
    if (!description) return '';
    return '   * ' + commentLines(description) + '\n';
  }

  return removeTrailingSpaces(
    '  /**\n' +
    formatDescription(command.description) +
    formatParameters(command.parameters || command.properties) +
    formatReturns(command.returns) +
    formatThrows(command.error) +
    '   */\n');
}

function showChange(old, replacement) {
  return '  - ' + old.trim().replace(/\n/g, '\n  - ') + '\n' +
         '  + ' + replacement.trim().replace(/\n/g, '\n  + ');
}

function templateMethod(agentClass, cmd) {
  return `  ${cmd}() {
    throw new Error('Not implemented');
  }`;
}

function agentBaseTemplate(name, agentClass) {
  return `'use strict';

const BaseAgent = require('../base');

class ${agentClass} extends BaseAgent {
  constructor() {
    super();
  }
}

module.exports = ${agentClass};
`;
}

protocol.domains.forEach(domain => {
  const name = domain.domain;
  const agentClass = name + 'Agent';
  const methodPatternStr = '(  /\\*\\*\n(?:[\\s]+\\*[^\n]*\n)*[\\s]+\\*/\n  )?' +
    '([\\w]+)\\(([^)]*)\\) \\{';
  const methodPattern = new RegExp(methodPatternStr, 'g');

  const implFilename = getAgentFilename(name);

  let source;
  try {
    source = fs.readFileSync(implFilename, 'utf8');
  } catch (err) {
    if (err.code !== 'ENOENT') {
      throw err;
    }
    /* eslint no-console: 0 */
    console.error('[warn] Not found: %j - %s', name, implFilename);

    try {
      fs.mkdirSync(path.dirname(implFilename));
    } catch (mkdirErr) {
      if (mkdirErr.code !== 'EEXIST') {
        throw mkdirErr;
      }
    }
    source = agentBaseTemplate(name, agentClass);
  }

  const methodsFound = [];
  let fixed = source.replace(methodPattern,
    (text, oldComment, cmd, paramsOpt) => {
      if (cmd === 'constructor' || cmd[0] === '_') {
        return text;
      }
      const params = paramsOpt || '';

      methodsFound.push(cmd);

      const cmdDesc = _.find(domain.commands, { name: cmd });
      if (!cmdDesc) {
        console.error(
          '[warn] Command seems to have been removed: %s.%s',
          name, cmd);
        return text;
      }
      const properComment = formatCommand(cmdDesc) + '  ';
      if (oldComment !== undefined && oldComment !== properComment) {
        console.error('%j\n%j', oldComment, properComment);
        console.error(
          '[info] Replacing comment for %s:\n%s', name + '.' + cmd,
          showChange(oldComment, properComment));
      }
      const postfix = cmd + '(' + params + ') {';
      return properComment + postfix;
    });

  domain.commands.forEach(cmdDesc => {
    const cmd = cmdDesc.name;

    if (methodsFound.indexOf(cmd) !== -1) {
      return;
    }
    console.error('[info] Adding missing %s', name + '.' + cmd);
    const properComment = formatCommand(cmdDesc);

    const newSource =
      '\n\n' + properComment + templateMethod(agentClass, cmd);
    fixed = fixed.replace('\n}\n', newSource + '\n}\n');
  });

  fs.writeFileSync(implFilename, fixed, 'utf8');

  // Generate types file
  const typesFilename = implFilename.replace(/index\.js$/, 'types.js');
  let typesSource = '\'use strict\';\n' +
    '// This file is auto-generated using scripts/doc-sync.js' +
    '\n\n';

  typesSource += (domain.types || []).map(typeSpec => {
    const prefix = formatCommand(typeSpec) + 'exports.' + typeSpec.id + ' =';
    switch (typeSpec.type) {
    case 'object':
      const argList = typeSpec.properties && typeSpec.properties.length ?
        '(props) {' : '() {';
      const ctorLines = (typeSpec.properties || []).map(prop => {
        return 'this.' + prop.name + ' = props.' + prop.name + ';';
      });
      const ctorBody = ctorLines.length ?
        '\n  ' + ctorLines.join('\n  ') : '';
      return prefix + '\nfunction ' + typeSpec.id + argList + ctorBody + '\n};\n';

    case 'array':
      return prefix + ' function ' + typeSpec.id + '(arr) { return arr; };\n';

    case 'string':
      return prefix + ' String;\n';

    case 'integer':
    case 'number':
      return prefix + ' Number;\n';

    case 'boolean':
      return prefix + ' Boolean;\n';

    default:
      throw new Error('Unknown type: ' + typeSpec.type);
    }
  }).join('\n');

  fs.writeFileSync(typesFilename, typesSource, 'utf8');
});
