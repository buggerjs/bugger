
{spawn} = require 'child_process'
{createServer, connect} = require 'net'
{_resolveFilename} = require 'module'
path = require 'path'
{defaults} = require 'underscore'

debugClient = require '../debug-client'

openDebugConnection = (childProcess) ->
  buffer = ''

  waitForDebugger = (chunk) ->
    buffer += chunk.toString()
    match = buffer.match /debugger listening/
    if match?
      buffer = null
      childProcess.stderr.removeListener 'data', waitForDebugger
      # connect to debug port port
      debugConnection = connect childProcess.debugPort, ->
        childProcess.debugConnection = debugConnection
        childProcess.debugClient = debugClient debugConnection
        childProcess.emit 'debugClient', childProcess.debugClient

  childProcess.stderr.on 'data', waitForDebugger

bugScript = (moduleName, childArgs, {debugBreak, language}, cb) ->
  moduleName = "./#{moduleName}" unless moduleName[0] is '/'
  try
    moduleName = _resolveFilename moduleName
  catch err
    return cb(err)

  # Find available port
  tmpServer = createServer ->
  tmpServer.listen 0, ->
    debugPort = @address().port
    tmpServer.close()
    tmpServer.on 'close', ->
      childArgs = [
        "--debug=#{debugPort}",
        path.join(__dirname, 'child.js'),
        moduleName
      ].concat childArgs

      options =
        stdio: ['pipe', 'pipe', 'pipe', 'ipc']
        env: defaults {}, process.env

      if debugBreak
        options.env.ENABLE_DEBUG_BREAK = '1'

      if language
        options.env.BUGGER_LANGUAGE = language

      forked = spawn process.argv[0], childArgs, options
      forked.debugPort = debugPort
      openDebugConnection forked

      cb(null, forked)

module.exports = bugScript
