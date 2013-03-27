
fs = require 'fs'
debug = require '../debug-client'
agents = require '../agents'

wrapperObject = (type, description, hasChildren, frame, scope, ref) ->
  type: type
  description: description
  hasChildren: hasChildren
  objectId: "#{frame}:#{scope}:#{ref}"

class SocketChannel
  constructor: ({ @socketConnection, @httpServer, @socketServer }) ->
    console.log '[bugger] SocketChannel created'

    @hiddenFilePatterns = []

    debug.on 'break', @onPauseOrBreakpoint

    @socketConnection.on 'message', (data) =>
      @handleRequest JSON.parse(data.utf8Data)

    @socketConnection.on 'disconnect', =>
      @socketConnection = null

    @syncBrowser()

  handleRequest: (msg) ->
    if msg.method
      [agentName, functionName] = msg.method.split('.')
      console.log "[agents.handleRequest] #{agentName}##{functionName}"

      args = []
      if msg.params
        args.push msg.params

      if (msg.id > 0)
        args.push (error, data...) =>
          @sendResponse msg.id, error, data
      else args.push ->

      agents.invoke agentName, functionName, args
    else
      console.log 'Unknown message from frontend:', msg

  sendResponse: (seq, err, data={}) ->
    if @socketConnection
      @socketConnection.send(JSON.stringify id: seq, error: err, result: data)
    else
      console.log 'Could not send response: ', req, data

  dispatchEvent: (method, params={}) ->
    if @socketConnection
      @socketConnection.send(JSON.stringify {method, params})
    else
      console.log 'Could not dispatch event: ', method, params

  syncBrowser: ->
    args = { arguments: { includeSource: true, types: 4 } }
    console.log '[debug.request] scripts', args
    debug.request 'scripts', args, (scriptsResponse) =>
      console.log '[debug.response] scripts'
      @sendParsedScripts scriptsResponse
      debug.request 'listbreakpoints', {}, (breakpointsResponse) =>
        breakpointsResponse.body.breakpoints.forEach (bp) =>
          if bp.type is 'scriptId'
            data =
              sourceID: bp.script_id
              url: debug.sourceIDs[bp.script_id].url
              line: bp.line
              enabled: bp.active
              condition: bp.condition
              number: bp.number

            breakpoints[bp.script_id + ':' + (bp.line)] = data
            # @sendEvent 'restoredBreakpoint', data
            # @dispatchEvent ?

        unless breakpointsResponse.running
          @sendBacktrace()

  onPauseOrBreakpoint: (breakDesc) =>
    scriptId = if breakDesc? then breakDesc.body.script.id else null
    source = debug.sourceIDs[scriptId] if scriptId?

    unless source?
      args =
        arguments:
          includeSource: true
          types: 4
          ids: if scriptId? then [breakDesc.body.script.id] else undefined

      debug.request 'scripts', args, @sendParsedScripts
    else if source?.hidden
      debug.request 'continue', { arguments: { stepaction: 'out' } }
      return
    @sendBacktrace()

  sendBacktrace: ->
    debug.request 'backtrace', { arguments: { inlineRefs: true } }, (backtraceResponse) =>
      callFrames = @mapCallFrames(backtraceResponse)
      @dispatchEvent 'Debugger.paused', details: callFrames

  mapCallFrames: (backtraceResponse) ->
    if backtraceResponse.body.totalFrames > 0
      console.log backtraceResponse.body.frames.map (frame, idx) ->
        "[frame #{idx}] #{frame.func.scriptId.toString()} @ #{frame.line};#{frame.column} (#{frame.func.inferredName})"

      backtraceResponse.body.frames.map (frame) ->
        return {
          id: frame.index
          functionName: frame.func.inferredName
          type: 'function'
          worldId: 1
          location:
            scriptId: frame.func.scriptId.toString()
            lineNumber: frame.line # frame.line is zero-indexed
            columnNumber: frame.column
          scopeChain: frame.scopes.map (scope) ->
            object: wrapperObject('object', frame.receiver.className, true, frame.index, scope.index, frame.receiver.ref)
            objectId: frame.index + ':' + scope.index + ':backtrace'
            type: switch scope.type
              when 1 then 'local'
              when 2 then 'with'
              when 3 then 'closure'
              when 4 then 'global'
        }
    else
      [{ type: 'program', location: { scriptId: 'internal' }, line: 0, id: 0, worldId: 1, scopeChain: [] }]

  sendParsedScripts: (scriptsResponse) =>
    scripts = scriptsResponse.body.map (s) ->
      scriptId: String(s.id)
      url: s.name
      data: s.source
      startLine: s.lineOffset
      path: String(s.name).split('/')
      isContentScript: false

    scripts.sort (a, b) -> a.path.length - b.path.length

    paths = []
    shorten = (s) ->
      for i in [s.length-1..0]
        p = s.slice(i).join '/'
        if paths.indexOf(p) is -1
          paths.push p
          return p

      return s.join '/'

    scripts.forEach (s) =>
      hidden = @hiddenFilePatterns and @hiddenFilePatterns.some( (r) -> r.test(s.url) )

      # TODO: better way for finding out if the script has a matching source map
      sourceMapMatch = s.data.match /\s\/\/@ sourceMappingURL=data:application\/json;base64,(.*)/
      s.sourceMapURL = null

      item = { hidden: hidden, path: s.url }
      s.url = s.path.join('/') # shorten s.path if s.path.length > 1
      item.url = s.url

      debug.sourceIDs[s.scriptId] = item
      debug.sourceUrls[item.url] = s.scriptId

      if sourceMapMatch
        s.sourceMapURL = "/_sourcemap/#{s.scriptId}"
        sourceMapDesc = JSON.parse (new Buffer(sourceMapMatch[1], 'base64')).toString('utf8')
        sourceMapDesc.sourcesContent = sourceMapDesc.sources.map (sourceFile) ->
          fs.readFileSync(sourceFile, 'utf8').toString()

        debug.sourceMaps[s.scriptId.toString()] = JSON.stringify sourceMapDesc

      delete s.path
      unless hidden
        # "scriptId","url","startLine","startColumn","endLine","endColumn","isContentScript","sourceMapURL","hasSourceURL"
        @dispatchEvent 'Debugger.scriptParsed', s
        # sendEvent 'parsedScriptSource', s

module.exports = socketChannel = (opts) ->
  new SocketChannel opts
