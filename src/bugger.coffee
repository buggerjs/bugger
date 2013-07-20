
{EventEmitter} = require 'events'

{parallel} = require 'async'
{omit, defaults} = require 'underscore'

bugScript = require './bug-script'
domains = require './domains'
inspectorServer = require './inspector'

buggerDefaults =
  debugBreak: true
  webport: 8058
  webhost: '127.0.0.1'
  hang: true
  stfu: false
  language: null
  propes: null

bugger = (buggerOpts = {}) ->
  defaults buggerOpts, buggerDefaults
  {debugBreak, webport, webhost, hang, stfu, language, probes} = buggerOpts

  buggerLog =
    if stfu then ->
    else (message) -> console.error message

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

    forked.on 'exit', (exitCode) ->
      if hang
        buggerLog "[bugger] Process exit with status #{exitCode}"
      else
        process.exit exitCode

    forked.on 'message', (message) ->
      if message.method?
        {method} = message
        params = omit message, 'method'
        domains.handle {method, params}

  wrapEmitter.run = run = (script, scriptArgs = []) ->
    tasks = [ startServer, startScript(script, scriptArgs, buggerOpts) ]
    parallel tasks, (err, [inspector, forked]) ->
      throw err if err?
      forked.on 'debugClient', (debugClient) ->
        wire {inspector, forked, debugClient, domains}
        argString = scriptArgs.map( (arg) -> JSON.stringify(arg) ).join(' ')
        buggerLog "[bugger] Debugging #{script} #{argString}"
        buggerLog "[bugger] #{inspector.DEFAULT_URL}"

  wrapEmitter

module.exports = bugger

unless module.parent?
  bugger().run 'examples/simple.js'
