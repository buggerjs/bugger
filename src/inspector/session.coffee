events = require 'events'
debugr = require './debugger'

exports.create = (debugConnection, config) ->
  debug = null
  conn = null
  # map from sourceID:lineNumber to breakpoint
  breakpoints = {}
  # map from sourceID to filename
  sourceIDs = {}
  sourceUrls = {}
  sourceMaps = {}
  # milliseconds to wait for a lookup
  LOOKUP_TIMEOUT = 2500
  # node function wrapper
  FUNC_WRAP = /^\(function \(exports, require, module, __filename, __dirname\) \{ ([\s\S]*)\n\}\)$/
  cpuProfileCount = 0  

  agents =
    Debugger:
      enable: (cb) ->
        console.log 'Debbuger#enable'
        cb(null, true)

      disable: (cb) ->
        console.log 'Debbuger#disable'
        cb(null, true)

      setPauseOnExceptions: ({state}, cb) ->
        console.log 'Debugger#setPauseOnExceptions', arguments[0]
        cb(null, true)

      setBreakpointsActive: ({active}, cb) ->
        console.log 'Debugger#setBreakpointsActive', arguments[0]
        cb(null, true)

      removeBreakpoint: ({breakpointId}, cb) ->
        debug.request 'clearbreakpoint', { arguments: { breakpoint: breakpointId } }, (msg) ->
          for id of breakpoints
            if breakpoints[id] is breakpointId
              delete breakpoints[id]
              break
          cb null

      setBreakpointByUrl: ({ lineNumber, url, columnNumber, condition }, cb) ->
        console.log 'setBreakpointByUrl', arguments
        enabled = true; sourceID = sourceUrls[url]
        if bp = breakpoints[sourceID + ':' + lineNumber]
          args = { arguments: { breakpoint: bp.breakpointId, enabled, condition } }
          debug.request 'changebreakpoint', args, (msg) ->
            bp.enabled = enabled
            bp.condition = condition
            cb null, bp.breakpointId, bp.locations
        else
          args = { type: 'scriptId', target: sourceID, line: lineNumber, enabled, condition }
          debug.request 'setbreakpoint', { arguments: args }, (msg) ->
            if msg.success
              b = msg.body
              bp = breakpoints[b.script_id + ':' + b.line] = {
                sourceID: b.script_id
                url: sourceIDs[b.script_id].url
                line: b.line
                breakpointId: b.breakpoint.toString()
                locations: b.actual_locations.map (l) ->
                  scriptId: l.script_id.toString()
                  lineNumber: l.line # lineNumber is zero-indexed; l.line is zero-indexed
                  columnNumber: l.column
                enabled: enabled
                condition: condition
              }

              cb null, bp.breakpointId, bp.locations

      pause: (cb) ->
        console.log 'Debugger#pause'
        debug.request 'suspend', {}, (msg) ->
          breakEvent()

      resume: (cb) ->
        console.log 'Debugger#resume'
        debug.request 'continue', {}, (msg) ->
          cb(null, true)

      stepOver: (cb) ->
        debug.request 'continue', { arguments: {stepaction: 'next'} }, (msg) ->
          cb(null, true)
        # sendEvent('resumedScript')

      stepInto: (cb) ->
        debug.request 'continue', { arguments: {stepaction: 'in'} }, (msg) ->
          cb(null, true)
        # sendEvent('resumedScript')

      stepOutOfFunction: (cb) ->
        debug.request 'continue', { arguments: {stepaction: 'out'} }, (msg) ->
          cb(null, true)
        # sendEvent('resumedScript')

      getScriptSource: ({scriptId}, cb) ->
        args =
          arguments:
            includeSource: true,
            types: 4,
            ids: [scriptId]
        debug.request 'scripts', args, (msg) ->
          cb null, msg.body[0].source

    Console:
      enable: (cb) ->
        console.log 'Console#enable'
        cb(null, true)

    Runtime:
      evaluate2: (options, cb) ->
        console.log 'Runtime#evaluate', options
        ###
        { expression: 'this',
          objectGroup: 'completion',
          includeCommandLineAPI: true,
          doNotPauseOnExceptions: true,
          returnByValue: false }
        ###
        {expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptions, returnByValue} = options
        args =
          expression: expression
          disable_break: doNotPauseOnExceptions
          global: true
          maxStringLength: 100000

        # if frame?
        #   args.frame = frame
        #   args.global = false

        console.log 'Runtime#evaluate - mapped', args
        debug.request 'evaluate', { arguments: args }, ->
          console.log 'Runtime#evaluate - cb', args
          console.log 'Options: ', options
          console.log 'Returned: ', arguments
          cb(arguments...)

      getProperties: ({objectId, ownProperties}, cb) ->
        [frame, scope, ref] = objectId.split ':'

        if ref is 'backtrace'
          debug.request 'scope', { arguments: { number: scope, frameNumber: frame, inlineRefs: true } }, (msg) ->
            if msg.success
              refs = {}
              if msg.refs and Array.isArray msg.refs
                msg.refs.forEach (r) ->
                  refs[r.handle] = r

              cb null, msg.body.object.properties.map (p) ->
                r = refs[p.value.ref]
                { name: p.name, value: refToObject r }
        else
          handle = parseInt ref, 10
          timeout = setTimeout( ->
            cb null, [{ name: 'sorry', value: wrapperObject( 'string', 'lookup timed out', false, 0, 0, 0) }]
            seq = 0
          LOOKUP_TIMEOUT)
          handles = [ handle ]
          debug.request 'lookup', { arguments: { handles, includeSource: false } }, (msg) ->
            clearTimeout(timeout)
            # TODO break out commonality with above
            if msg.success
              refs = {}
              props = []
              if msg.refs && Array.isArray(msg.refs)
                obj = msg.body[handle]
                objProps = obj.properties
                proto = obj.protoObject
                refs[r.handle] = r for r in msg.refs

                props = objProps.map (p) ->
                  r = refs[p.ref]
                  { name: String(p.name), value: refToObject(r) }

                if proto
                  props.push
                    name: '__proto__',
                    value: refToObject refs[proto.ref]
              cb(null, props)
            else
              console.log '[error] Runtime#getProperties', msg

  wrapperObject = (type, description, hasChildren, frame, scope, ref) ->
    type: type
    description: description
    hasChildren: hasChildren
    objectId: "#{frame}:#{scope}:#{ref}"

  refToObject = (ref) ->
    desc = ''
    name = null
    kids = if ref.properties then ref.properties.length else false

    switch ref.type
      when 'object'
        name = /#<an?\s(\w+)>/.exec ref.text
        if name?.length > 1
          desc = name[1]
          if desc is 'Array'
            desc += '[' + (ref.properties.length - 1) + ']'
          else if desc is 'Buffer'
            desc += '[' + (ref.properties.length - 4) + ']'
        else
          desc = ref.className ? 'Object'
      when 'function'
        desc = ref.text ? 'function()'
      else
        desc = ref.text ? ''

    desc = desc.substring(0, 100) + '\u2026' if desc.length > 100
    
    wrapperObject ref.type, desc, kids, 0, 0, ref.handle

  mapCallFrames = (bt) ->
    if bt.body.totalFrames > 0
      console.log bt.body.frames.map (frame, idx) ->
        "[frame #{idx}] #{frame.func.scriptId.toString()} @ #{frame.line};#{frame.column} (#{frame.func.inferredName})"

      bt.body.frames.map (frame) ->
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

  evaluate = (expr, frame, andThen) ->
    args =
      expression: expr
      disable_break: true
      global: true
      maxStringLength: 100000

    if frame?
      args.frame = frame
      args.global = false

    debug.request 'evaluate', { arguments: args }, andThen

  sendBacktrace = ->
    debug.request 'backtrace', { arguments: { inlineRefs: true } }, (msg) ->
      callFrames = mapCallFrames(msg)
      dispatchEvent 'Debugger.paused', details: callFrames

  breakEvent = (obj) ->
    scriptId = if obj? then obj.body.script.id else null
    source = sourceIDs[scriptId] if scriptId?

    unless source?
      args =
        arguments:
          includeSource: true
          types: 4
          ids: if scriptId? then [obj.body.script.id] else undefined

      debug.request 'scripts', args, parsedScripts
    else if source?.hidden
      debug.request 'continue', { arguments: { stepaction: 'out' } }
      return
    sendBacktrace()

  parsedScripts = (msg) ->
    scripts = msg.body.map (s) ->
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
      hidden = config.hidden and config.hidden.some( (r) -> r.test(s.url) )

      sourceMapMatch = s.data.match /\s\/\/@ sourceMappingURL=data:application\/json;base64,(.*)/
      s.sourceMapURL = null

      if sourceMapMatch
        s.sourceMapURL = "/_sourcemap/#{s.scriptId}"
        sourceMaps[s.scriptId.toString()] = JSON.parse (new Buffer(sourceMapMatch[1], 'base64')).toString('utf8')

      item = { hidden: hidden, path: s.url }
      s.url = s.path.join('/') # shorten s.path if s.path.length > 1
      item.url = s.url

      sourceIDs[s.scriptId] = item
      sourceUrls[item.url] = s.scriptId
      delete s.path
      unless hidden
        # "scriptId","url","startLine","startColumn","endLine","endColumn","isContentScript","sourceMapURL","hasSourceURL"
        dispatchEvent 'Debugger.scriptParsed', s
        # sendEvent 'parsedScriptSource', s

  sendProfileHeader = (title, uid, type) ->
    sendEvent 'addProfileHeader',
      header:
        title: title
        uid: uid
        typeId: type

  sendEvent = (name, data={}) ->
    if conn
      conn.send(JSON.stringify
        type: 'event'
        event: name
        data: data
      )

  dispatchEvent = (method, params={}) ->
    if conn
      conn.send(JSON.stringify {method, params})
    else
      console.log 'Could not send: ', method, params

  sendResponse = (seq, success, data={}) ->
    if conn
      conn.send(JSON.stringify
        id: seq
        error: null
        result: data
      )

  browserConnected = -> # TODO find a better name
    args = { arguments: { includeSource: true, types: 4 } }
    console.log '[debug.request] scripts', args
    debug.request 'scripts', args, (msg) ->
      console.log '[debug.response] scripts'
      parsedScripts msg
      debug.request 'listbreakpoints', {}, (msg) ->
        msg.body.breakpoints.forEach (bp) ->
          if bp.type is 'scriptId'
            data =
              sourceID: bp.script_id
              url: sourceIDs[bp.script_id].url
              line: bp.line
              enabled: bp.active
              condition: bp.condition
              number: bp.number

            breakpoints[bp.script_id + ':' + (bp.line)] = data
            sendEvent 'restoredBreakpoint', data

        unless msg.running
          sendBacktrace()

  return Object.create(events.EventEmitter.prototype, {
    getSourceMap:
      value: (id) -> sourceMaps[id]

    attach:
      value: ->
        debug = debugr.attachDebugger debugConnection
        debug.on 'break', breakEvent
        debug.on 'close', =>
          # TODO determine proper close behavior
          debug =
            request: -> console.error 'debugger not connected'
          sendEvent 'debuggerWasDisabled'
          @close()

        debug.on 'connect', ->
          browserConnected()

        debug.on 'exception', (msg) ->
          breakEvent msg

        debug.on 'error', (e) ->
          sendEvent 'showPanel', { name: 'console' }
          err = e.toString()
          if err.match /ECONNREFUSED/
            err += '\nIs node running with --debug?'

          data =
            messageObj:
              source: 3,
              type: 0,
              level: 3,
              line: 0,
              url: '',
              groupLevel: 7,
              repeatCount: 1,
              message: err

          sendEvent 'addConsoleMessage', data

    close:
      value: ->
        if debug and debug.connected
          debug.close()
        @emit 'close'

    # Backend
    enableDebugger:
      value: (always) ->
        @attach()

    dispatchOnInjectedScript:
      value: (injectedScriptId, methodName, argString, seq) ->
        args = JSON.parse argString
        if methodName is 'getProperties'
          objectId = args[0]
          tokens = objectId.split ':'

          frame = parseInt(tokens[0], 10)
          scope = parseInt(tokens[1], 10)
          ref = tokens[2]

          if ref is 'backtrace'
            debug.request 'scope', { arguments: { number: scope, frameNumber: frame, inlineRefs: true } }, (msg) ->
              if msg.success
                refs = {}
                if msg.refs and Array.isArray msg.refs
                  msg.refs.forEach (r) ->
                    refs[r.handle] = r

                props = msg.body.object.properties.map (p) ->
                  r = refs[p.value.ref]
                  return { name: p.name, value: refToObject r }

                sendResponse(seq, true, result: props)
          else
            handle = parseInt ref, 10
            timeout = setTimeout( ->
              sendResponse(seq, true, {
                result: [{
                  name: 'sorry',
                  value: wrapperObject('string', 'lookup timed out', false, 0, 0, 0)
                }]
              })
              seq = 0
            LOOKUP_TIMEOUT)
            debug.request 'lookup', { arguments: { handles: [handle], includeSource: false } }, (msg) ->
              clearTimeout(timeout)
              # TODO break out commonality with above
              if msg.success && seq != 0
                refs = {}
                props = []
                if msg.refs && Array.isArray(msg.refs)
                  obj = msg.body[handle]
                  objProps = obj.properties
                  proto = obj.protoObject
                  msg.refs.forEach (r) ->
                    refs[r.handle] = r

                  props = objProps.map (p) ->
                    r = refs[p.ref]
                    return {
                      name: String(p.name)
                      value: refToObject(r)
                    }

                  if proto
                    props.push({
                      name: '__proto__',
                      value: refToObject(refs[proto.ref])
                    })
                sendResponse(seq, true, { result: props })

        else if (methodName is 'getCompletions')
          expr = args[0]
          data = {
            result: {}
            isException: false
          }
          # expr looks to be empty "" a lot so skip evaluate
          if (expr is '')
            sendResponse(seq, true, data)
            return

          evaluate expr, args[2], (msg) ->
            if msg.success && msg.body.properties && msg.body.properties.length < 256
              msg.body.properties.forEach( (p) ->
                data.result[p.name] = true
              )
            sendResponse seq, true, data
        else
          evalResponse = (msg) ->
            if msg.success
              sendResponse(seq, true, { result: refToObject(msg.body), isException: false })
            else
              sendResponse(seq, true, { result: { type: 'error', description: msg.message }, isException: false })

          if methodName is 'evaluateInCallFrame'
            evaluate args[1], args[0], evalResponse
          else if methodName is 'evaluate'
            evaluate args[0], null, evalResponse

    # Controller
    disableDebugger:
      value: (always) ->
        if (debug && debug.connected)
          debug.close()

    populateScriptObjects:
      value: (seq) ->
        sendResponse(seq, true, {})

    getInspectorState:
      value: (seq) ->
        sendResponse(seq, true, { state: { monitoringXHREnabled: false, resourceTrackingEnabled: false } })

    getResourceContent:
      value: (identifier, encode) ->
        # ???

    enableProfiler:
      value: (always) ->
        if debug && debug.connected
          evaluate 'process.profiler !== undefined', null, (msg) ->
            if (msg.body.value)
              sendEvent('profilerWasEnabled')
            else
              sendEvent('showPanel', { name: 'console' })
              sendEvent 'addConsoleMessage', {
                messageObj: {
                  source: 3,
                  type: 0,
                  level: 2,
                  line: 0,
                  url: '',
                  repeatCount: 1,
                  message: 'you must require("v8-profiler") to use the profiler'
                }
              }
        else
          sendEvent('showPanel', { name: 'console' })
          sendEvent 'addConsoleMessage', {
            messageObj:
              source: 3,
              type: 0,
              level: 2,
              line: 0,
              url: '',
              repeatCount: 1,
              message: 'not connected to node'
          }

    disableProfiler:
      value: (always) ->

    clearConsoleMessages:
      value: -> sendEvent('consoleMessagesCleared')

    # Debug
    activateBreakpoints: {
      value: ->
        Object.keys(breakpoints).forEach (key) ->
          bp = breakpoints[key];
          debug.request 'changebreakpoint', {
            arguments: {
              breakpoint: bp.number,
              condition: bp.condition,
              enabled: true
            }
          }, (msg) ->
            if (msg.success)
              bp.enabled = true;
              sendEvent('restoredBreakpoint', bp)
    },
    deactivateBreakpoints: {
      value: (injectedScriptId, objectGroup) ->
        Object.keys(breakpoints).forEach (key) ->
          bp = breakpoints[key];
          debug.request 'changebreakpoint', {
            arguments: {
              breakpoint: bp.number,
              condition: bp.condition,
              enabled: false
            }
          }, (msg) ->
            if (msg.success)
              bp.enabled = false;
              sendEvent('restoredBreakpoint', bp)
    },
    pause: {
      value: ->
        debug.request('suspend', {}, (msg) ->
          if (!msg.running)
            sendBacktrace()
        )
    },
    resume: {
      value: ->
        debug.request('continue')
        sendEvent('resumedScript')
    },
    stepOverStatement: {
      value: ->
        debug.request('continue', { arguments: {stepaction: 'next'}})
        sendEvent('resumedScript')
    },
    stepIntoStatement: {
      value: ->
        debug.request('continue', { arguments: {stepaction: 'in'}})
        sendEvent('resumedScript')
    },
    stepOutOfFunction: {
      value: ->
        debug.request('continue', { arguments: {stepaction: 'out'}})
        sendEvent('resumedScript')
    },
    setPauseOnExceptionsState: {
      value: (state, seq) ->
        params = {
          arguments: {
            flags: [{
              name: 'breakOnCaughtException',
              value: state is 1
            }]
          }
        }
        debug.request('flags', params, (msg) ->
          value = 0;
          if msg.success
            if msg.body.flags.some( (x) -> x.name is 'breakOnCaughtException' && x.value )
              value = 1
            sendResponse(seq, true, {pauseOnExceptionState: value})
        )
    },
    editScriptSource: {
      value: (sourceID, newContent, seq) ->
        args = {
          script_id: sourceID,
          preview_only: false,
          new_source: newContent
        }
        debug.request 'changelive', {arguments: args}, (msg) ->
          sendResponse seq, true, {
            success: msg.success,
            newBodyOrErrorMessage: msg.message || newContent
          }
          # TODO: new callframes?
          if msg.success && config.saveLiveEdit
            fs = require('fs')
            match = FUNC_WRAP.exec(newContent)
            newSource = null
            if (match && sourceIDs[sourceID] && sourceIDs[sourceID].path)
              newSource = match[1]
              fs.writeFile sourceIDs[sourceID].path, newSource, (e) ->
                return null unless e
                err = e.toString()
                data = {
                  messageObj: { source: 3, type: 0, level: 3, line: 0, url: '', groupLevel: 7, repeatCount: 1, message: err }
                }
                sendEvent('addConsoleMessage', data)
    },
    getScriptSource: {
      value: (sourceID, seq) ->
        # unobserved / unverified
        args = {
          arguments: {
            includeSource: true,
            types: 4,
            ids: [sourceID]
          }
        }
        debug.request('scripts', args, (msg) ->
          sendResponse(seq, msg.success, { scriptSource: msg.body[0].source })
        )
    },
    # Profiler
    startProfiling: {
      value: ->
        ###
        HACK
         * changed the behavior here since using eval doesn't profile the
         * correct context. Using as a 'refresh' in the mean time
         * Remove this hack once we can trigger a profile in the proper context
        ###
        sendEvent('setRecordingProfile', { isProfiling: false })
        this.getProfileHeaders()
    },
    stopProfiling: {
      value: ->
        expr = 'process.profiler.stopProfiling("org.webkit.profiles.user-initiated.' + cpuProfileCount + '")'
        evaluate expr, null, (msg) ->
          sendEvent 'setRecordingProfile', { isProfiling: false }
          if msg.success
            refs = {}
            profile = {}
            if msg.refs && Array.isArray(msg.refs)
              obj = msg.body
              objProps = obj.properties
              msg.refs.forEach (r) ->
                refs[r.handle] = r

              objProps.forEach (p) ->
                profile[String(p.name)] = refToObject(refs[p.ref]).description

            sendProfileHeader parseInt(profile.uid, 10), 'CPU'
    },
    getProfileHeaders: {
      value: ->
        evaluate 'process.profiler.profileCount()', null, (msg1) ->
          if (msg1.success)
            for i in [0..msg1.body.value]
              evaluate 'process.profiler.getProfile(' + i + ')', null, (msg) ->
                if (msg.success)
                  refs = {};
                  profile = {};
                  if (msg.refs && Array.isArray(msg.refs))
                    obj = msg.body;
                    objProps = obj.properties;
                    msg.refs.forEach (r) ->
                      refs[r.handle] = r

                    objProps.forEach (p) ->
                      profile[String(p.name)] = refToObject(refs[p.ref]).description

                  sendProfileHeader profile.title, parseInt(profile.uid, 10), 'CPU'

        evaluate 'process.profiler.snapshotCount()', null, (msg1) ->
          if (msg1.success)
            for i in [0..msg1.body.value]
              evaluate 'process.profiler.getSnapshot(' + i + ')', null, (msg) ->
                if (msg.success)
                  refs = {}
                  profile = {}
                  if (msg.refs && Array.isArray(msg.refs))
                    obj = msg.body
                    objProps = obj.properties
                    msg.refs.forEach (r) ->
                      refs[r.handle] = r

                    objProps.forEach (p) ->
                      profile[String(p.name)] = refToObject(refs[p.ref]).description

                  title =
                    if profile.title is 'undefined'
                      'org.webkit.profiles.user-initiated.' + profile.ui
                    else
                      profile.title

                  sendProfileHeader(title, parseInt(profile.uid, 10), 'HEAP')
    },
    getProfile: {
      value: (type, uid, seq) ->
        expr = switch type
          when 'HEAP'
            'process.profiler.findSnapshot(' + uid + ').stringify()'
          when 'CPU'
            'process.profiler.findProfile(' + uid + ').stringify()'
          else null
        evaluate(expr, null, (msg) ->
          sendResponse(seq, true, {
            profile: {
              title: 'org.webkit.profiles.user-initiated.' + uid,
              uid: uid,
              typeId: type,
              head: JSON.parse(msg.body.value)
            }
          })
        )
    },
    removeProfile: {
      value: (type, uid) ->
    },
    clearProfiles: {
      value: ->
    },
    takeHeapSnapshot: {
      value: ->
        evaluate 'process.profiler.takeSnapshot()', null, (msg) ->
          if (msg.success)
            refs = {}
            profile = {}
            if (msg.refs && Array.isArray(msg.refs))
              obj = msg.body
              objProps = obj.properties
              msg.refs.forEach (r) ->
                refs[r.handle] = r

              objProps.forEach (p) ->
                profile[String(p.name)] = refToObject(refs[p.ref]).description

            sendProfileHeader 'org.webkit.profiles.user-initiated.' + profile.uid, parseInt(profile.uid, 10), 'HEAP'
    },
    join: {
      value: (ws_connection) ->
        conn = ws_connection;
        conn.on 'message', (data) =>
          @handleRequest data.utf8Data

        conn.on 'disconnect', =>
          # TODO what to do here? set timeout to close debugger connection
          @emit('ws_closed')
          conn = null

        browserConnected()
    },
    handleRequest: {
      value: (data) ->
        msg = JSON.parse(data)

        if msg.method
          [agentName, functionName] = msg.method.split('.')
          console.log "[agents.handleRequest] #{agentName}##{functionName}"

          args = []
          if msg.params
            args.push msg.params

          if (msg.id > 0)
            args.push (error, data...) ->
              sendResponse msg.id, error, data

          agent = agents[agentName]
          handlerFn = agent[functionName]

          handlerFn.apply(agent, args)
        else
          console.log 'Unknown message from frontend:', msg

        if typeof command is 'function'
          args = Object.keys(msg.arguments).map (x) -> msg.arguments[x]
          if msg.seq > 0
            args.push msg.seq
          command.apply this, args
    }
  })
