
{parallel} = require 'async'

bugScript = require './bug-script'
domains = require './domains'
inspectorServer = require './inspector'

bugger = (debugBreak = true, webport = 8058, webhost = '127.0.0.1') ->
  startServer = (cb) ->
    inspector = inspectorServer()
    inspector.listen webport, webhost, ->
      cb null, inspector

  startScript = (script, scriptArgs, options) -> (cb) ->
    bugScript script, scriptArgs, options, cb

  wireStdIO = (forked) ->
    forked.stdout.pipe(process.stdout)
    forked.stderr.pipe(process.stderr)
    process.stdin.pipe(forked.stdin)

  wire = ({inspector, forked, debugClient, domains}) ->
    # Pipe stdout/stderr/stdin
    wireStdIO forked

    debugClient.on 'error', (err) ->
      console.log '[bugger] [error]', err.message

    # Load all the fancy handlers (and make debugClient <-> XAgent work)
    domains.load {debugClient}

    # Make the Websocket <-> XAgent binding work
    inspector.on 'request', domains.handle
    domains.on 'notification', inspector.dispatchEvent

  run = (script, scriptArgs = []) ->
    tasks = [ startServer, startScript(script, scriptArgs, {debugBreak}) ]
    parallel tasks, (err, [inspector, forked]) ->
      forked.on 'debugClient', (debugClient) ->
        wire {inspector, forked, debugClient, domains}
        argString = scriptArgs.map( (arg) -> JSON.stringify(arg) ).join(' ')
        console.log "[bugger] Debugging #{script} #{argString}"
        console.log "[bugger] #{inspector.DEFAULT_URL}"

  {run}

module.exports = bugger

unless module.parent?
  bugger().run 'examples/simple.js'
