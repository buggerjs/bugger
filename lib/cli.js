'use strict';

const path = require('path');

const startDebug = require('./embedded-agents');

const mainModule = path.resolve(process.cwd(), process.argv[2]);
startDebug(mainModule);
