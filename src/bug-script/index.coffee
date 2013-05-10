
{spawn} = require 'child_process'
{createServer, connect} = require 'net'
{_resolveFilename} = require 'module'
# {defaults} = require 'underscore'
path = require 'path'

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
        childProcess.emit 'debugConnection', debugConnection

  childProcess.stderr.on 'data', waitForDebugger

bugScript = (moduleName, childArgs..., cb) ->
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

      forked = spawn process.argv[0], childArgs, options
      forked.debugPort = debugPort
      openDebugConnection forked

      cb(null, forked)

module.exports = bugScript
