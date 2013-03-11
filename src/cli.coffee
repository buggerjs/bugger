
{resolveModule} = require './bugger'
{DebugServer} = require './inspector/server'
forkChrome = require('./forked/chrome')
{forkEntryScript} = require('./forked/entry_script')

module.exports =
  run: ->
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
      'debug-port':
        default: 5858
        describe: 'Debug port used by node'
      chrome:
        boolean: true
        describe: 'Open Chrome with the correct url'
      'brk':
        describe: 'Break on first line of script'
        boolean: true,
        default: true
      'web-host':
        default: '127.0.0.1'
        describe: 'Web host used by node-inspector'
      'web-port':
        default: 8058
        describe: 'Web port used by node-inspector'
    )

    argv = argvParser.argv

    if argv.version
      console.log require('./package.json').version
      process.exit 0

    if argv.help
      argvParser.showHelp()
      process.exit 0

    unless argv._.length
      argvParser.showHelp()
      process.exit 1

    # Resolve to proper module.
    entryScript = resolveModule argv._[0]
    unless entryScript?
      throw new Error('File not found: ' + argv._[0])

    debugPort = argv['debug-port']

    # Start child processes that will handle the debugging server and chrome
    if argv.chrome
      chrome = forkChrome(argv['web-host'], argv['web-port'], debugPort)
      chrome.on 'exit', process.exit

    forkEntryScript entryScript, debugPort, argv['brk'], argv._, ({ entryScriptProc, debugConnection }) ->
      entryScriptProc.on 'exit', process.exit

      debugServer = (new DebugServer()).start {
        webHost: argv['web-host']
        webPort: argv['web-port']
        debugConnection: debugConnection
      }

      process.on 'exit', ->
        try chrome.kill() if argv.chrome
        try entryScriptProc.kill()
        try debugServer.close()
