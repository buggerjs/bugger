
{spawn} = require 'child_process'
{createServer, connect} = require 'net'
{_resolveFilename} = require 'module'
# {defaults} = require 'underscore'
path = require 'path'

class BackChannel
  constructor: (@childProcess) ->
    @buffer = ''
    @connection = null
    @childProcess.stderr.on 'data', @waitForDebugger

  waitForDebugger: (chunk) =>
    @buffer += chunk.toString()
    match = @buffer.match /debugger listening/
    if match?
      @childProcess.stderr.removeListener 'data', @waitForDebugger
      @buffer = null

      # connect to debug port port
      @childProcess.debugConnection = connect @childProcess.debugPort, =>
        @childProcess.emit 'debugConnection'

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

    childArgs = [
      "--debug=#{debugPort}",
      path.join(__dirname, 'child.js'),
      moduleName
    ].concat childArgs

    options =
      stdio: ['pipe', 'pipe', 'pipe', 'ipc']

    forked = spawn process.argv[0], childArgs, options
    forked.backChannel = new BackChannel(forked)
    forked.debugPort = debugPort

    cb(null, forked)

module.exports = bugScript
