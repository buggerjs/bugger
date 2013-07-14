
{EventEmitter} = require 'events'

{parallel} = require 'async'
{omit} = require 'underscore'

bugScript = require './bug-script'
domains = require './domains'
inspectorServer = require './inspector'

bugger = (debugBreak = true, webport = 8058, webhost = '127.0.0.1') ->
  startServer = (cb) ->
    inspector = inspectorServer()
    inspector.listen webport, webhost, ->
      cb null, inspector

  wrapEmitter = new EventEmitter()

  forwardErrors = (internalObjects...) ->
    for internalObj in internalObjects
      internalObj.on 'error', (err) ->
        wrapEmitter.emit 'error', err

  startScript = (script, scriptArgs, options) -> (cb) ->
    bugScript script, scriptArgs, options, cb

  wireStdIO = (forked) ->
    forked.stdout.pipe(process.stdout)
    forked.stderr.pipe(process.stderr)
    process.stdin.pipe(forked.stdin)

  wire = ({inspector, forked, debugClient, domains}) ->
    # Pipe stdout/stderr/stdin
    wireStdIO forked

    forwardErrors debugClient, domains, forked, inspector

    # Load all the fancy handlers (and make debugClient <-> XAgent work)
    domains.load {debugClient, forked}

    # Make the Websocket <-> XAgent binding work
    inspector.on 'request', domains.handle
    domains.on 'notification', inspector.dispatchEvent

    forked.on 'message', (message) ->
      if message.method?
        {method} = message
        params = omit message, 'method'
        domains.handle {method, params}

  wrapEmitter.run = run = (script, scriptArgs = []) ->
    tasks = [ startServer, startScript(script, scriptArgs, {debugBreak}) ]
    parallel tasks, (err, [inspector, forked]) ->
      forked.on 'debugClient', (debugClient) ->
        wire {inspector, forked, debugClient, domains}
        argString = scriptArgs.map( (arg) -> JSON.stringify(arg) ).join(' ')
        console.log "[bugger] Debugging #{script} #{argString}"
        console.log "[bugger] #{inspector.DEFAULT_URL}"

  wrapEmitter

module.exports = bugger

unless module.parent?
  bugger().run 'examples/simple.js'
