# We use optimist for parsing the CLI arguments
argvParser = require('optimist')
.usage(
  'bugger [OPTIONS] FILE_NAME'
).options(
  version:
    alias: 'v'
    describe: 'Just show version information'
    boolean: true
  help:
    alias: 'h'
    describe: 'Show this text'
    boolean: true
  brk:
    describe: 'Break on first line of script'
    boolean: true
    default: true
  webhost:
    default: '127.0.0.1'
    describe: 'Web host used by node-inspector'
  webport:
    default: 8058
    describe: 'Web port used by node-inspector'
  hang:
    default: false
    describe: 'Keep running after the script terminated'
    boolean: true
  stfu:
    default: false
    describe: 'bugger itself will not print anything anywhere'
    boolean: true
  language:
    describe: 'Force detection of entry script language. Supported: "js" and "coffee"'
  probes:
    describe: 'Comma separated list of probes to enable, defaults to all of \'em'
)

argv = argvParser.argv

if argv.version
  version = require('../package.json').version
  process.stdout.write "#{version}\n"
  process.exit 0

if argv.help
  argvParser.showHelp()
  process.exit 0

unless argv._.length
  argvParser.showHelp()
  process.exit 1

{pick} = require 'underscore'
buggerOptions = pick argv, 'webport', 'webhost', 'hang', 'stfu', 'language', 'probes'
buggerOptions.debugBreak = argv.brk

# debugBreak = true, webport = 8058, webhost = '127.0.0.1'
bugger = require('./bugger') buggerOptions
script = argv._.shift()
scriptArgs = argv._

bugger.on 'error', (err) ->
  return if argv.stfu
  console.error '[bugger] [error]', err.message
  console.error err.stack

bugger.run script, scriptArgs
