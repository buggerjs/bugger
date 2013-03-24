
debug = require '../debug-client'

class SocketChannel
  constructor: ({ @socketConnection, @httpServer, @socketServer }) ->
    console.log '[bugger] SocketChannel created'

    @hiddenFilePatterns = []

    @syncBrowser()

  dispatchEvent: (method, params={}) ->
    if @socketConnection
      @socketConnection.send(JSON.stringify {method, params})
    else
      console.log 'Could not send: ', method, params

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

  sendParsedScripts: (scriptsResponse) ->
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

    scripts.forEach (s) ->
      hidden = @hiddenFilePatterns and @hiddenFilePatterns.some( (r) -> r.test(s.url) )

      # TODO: better way for finding out if the script has a matching source map
      sourceMapMatch = s.data.match /\s\/\/@ sourceMappingURL=data:application\/json;base64,(.*)/
      s.sourceMapURL = null

      if sourceMapMatch
        s.sourceMapURL = "/_sourcemap/#{s.scriptId}"
        sourceMaps[s.scriptId.toString()] = JSON.parse (new Buffer(sourceMapMatch[1], 'base64')).toString('utf8')

      item = { hidden: hidden, path: s.url }
      s.url = s.path.join('/') # shorten s.path if s.path.length > 1
      item.url = s.url

      debug.sourceIDs[s.scriptId] = item
      debug.sourceUrls[item.url] = s.scriptId
      delete s.path
      unless hidden
        # "scriptId","url","startLine","startColumn","endLine","endColumn","isContentScript","sourceMapURL","hasSourceURL"
        @dispatchEvent 'Debugger.scriptParsed', s
        # sendEvent 'parsedScriptSource', s

module.exports = socketChannel = (opts) ->
  new SocketChannel opts
