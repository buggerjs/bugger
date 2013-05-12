
{EventEmitter} = require 'events'

{defaults} = require 'underscore'
{series} = require 'async'

mapValue = require './map/value'
mapScope = require './map/scope'
mapFrame = require './map/frame'
mapScript = require './map/script'

NEXT_SEQ = 0

debugParser = (stream) ->
  buffer = ''
  emitter = new EventEmitter()

  emptyMessage = ->
    { headers: null, contentLength: 0 }
  currentMessage = emptyMessage()

  parseHeaders = ->
    offset = buffer.indexOf '\r\n\r\n'
    return false unless offset > 0
    currentMessage.headers = buffer.substr 0, offset + 4
    contentLengthMatch = /Content-Length: (\d+)/.exec currentMessage.headers
    if contentLengthMatch[1]
      currentMessage.contentLength = parseInt contentLengthMatch[1], 10
    else
      emitter.emit 'error', new Error('No Content-Length')

    buffer = buffer.substr offset + 4
    true

  parseBody = ->
    {contentLength} = currentMessage
    return false unless Buffer.byteLength(buffer) >= contentLength

    # parse body
    b = new Buffer buffer
    body = b.toString 'utf8', 0, currentMessage.contentLength
    buffer = b.toString 'utf8', currentMessage.contentLength, b.length

    if body.length > 0
      try
        obj = JSON.parse body
        emitter.emit "parsed:#{obj.type}", obj
      catch error
        emitter.emit 'error', error
      # if obj.type is 'response' and obj.request_seq > 0
      #   emitter.emit 'response'
      #   @callbackHandler.processResponse obj.request_seq, [obj]
      # else if obj.type is 'event'
      #   @emit obj.event, obj

    currentMessage = emptyMessage()
    true

  parseBuffer = ->
    madeProgress = true
    while madeProgress
      madeProgress =
        unless currentMessage.headers?
          parseHeaders()
        else
          parseBody()

  stream.on 'data', (chunk) ->
    buffer += chunk
    parseBuffer buffer

  return emitter

callbackWrapper = ->
  callbackBySeq = {}
  lastSeq = 0

  wrapCallback = (cb) ->
    callbackBySeq[++lastSeq] = cb
    lastSeq

  unwrapCallback = (obj) ->
    {request_seq, success} = obj
    cb = callbackBySeq[request_seq]
    if success
      refMap = {}
      if Array.isArray(obj.refs)
        refMap[ref.handle] = ref for ref in obj.refs
      cb null, obj.body, refMap
    else
      cb new Error "#{obj.message} - #{JSON.stringify obj}"

  {wrapCallback, unwrapCallback}

module.exports = debugClient = (debugConnection) ->
  client = new EventEmitter()
  client.running = true

  debugConnection.setEncoding 'utf8'

  {wrapCallback, unwrapCallback} = callbackWrapper()

  parser = debugParser debugConnection
  parser.on 'parsed:response', (obj) ->
    client.running = obj.running if obj.running?
    unwrapCallback obj

  parser.on 'parsed:event', (obj) ->
    {success, running} = obj
    client.running = running if running?
    {event, body, refs} = obj
    if typeof client['emit_' + event] is 'function'
      client['emit_' + event] body, refs
    else
      err = new Error('Unknown debug event: ' + event)
      client.emit 'error', err

  sendString = (data) ->
    if debugConnection.writable
      debugConnection.write "Content-Length: #{data.length}\r\n\r\n#{data}"
    else
      client.emit 'error', new Error('Debug connection not writable')
      client.emit 'close'

  sendRequest = (command, params, cb) ->
    messageObj =
      type: 'request'
      command: command
      seq: wrapCallback(cb)

    if Object.keys(params).length > 0
      messageObj.arguments = params

    sendString JSON.stringify messageObj

  registerRequest = (command, mapBody) ->
    mapBody ?= (refs) -> (b) -> b

    client[command] = (params, cb) ->
      params =
        if typeof params is 'function'
          cb = params
          {}
        else
          params ? {}

      sendRequest command, params, (err, body, refs) ->
        return unless cb?
        if body?
          reffedMap = mapBody(refs)
          if reffedMap.length == 1
            cb null, reffedMap(body)
          else
            reffedMap body, cb
        else
          cb(err, body)

  registerEvent = (event, mapBody) ->
    mapBody ?= (refs) -> (b) -> b

    client['emit_' + event] = (body, refs) ->
      body = mapBody(refs)(body) if body?
      client.emit event, body

  registerEvent 'afterCompile', (refs) -> ({script}) ->
    mapScript(refs) script

  registerEvent 'break'

  # Script is no longer active (?)
  registerEvent 'scriptCollected', (refs) -> ({script}) ->
    { scriptId: script.id }

  registerEvent 'exception', (refs) -> (body) ->
    body

  # The request continue is a request from the debugger to start the VM
  # running again. As part of the continue request the debugger can specify if
  # it wants the VM to perform a single step action.
  #
  # In the response the property running will always be true as the VM will be
  # running after executing the continue command. If a single step action is
  # requested the VM will respond with a break event after running the step.
  #
  # @param stepaction in|next|out?
  # @param stepcount integer? Number of steps (default 1)
  registerRequest 'continue'

  registerRequest 'suspend'

  # The request evaluate is used to evaluate an expression. The body of the
  # result is as described in response object serialization below.
  #
  # Optional argument additional_context specifies handles that will be
  # visible from the expression under corresponding names (see example below).
  #
  # @param expression string Expression to evaluate
  # @param frame integer
  # @param global boolean
  # @param disable_break boolean
  # @param additional_context {name,handle}[]?
  # @returns RemoteValue
  registerRequest 'evaluate', mapValue

  # The request lookup is used to lookup objects based on their handle. The
  # individual array elements of the body of the result is as described in
  # response object serialization below.
  #
  # @param handles integer[] Array of handles
  # @param includeSource boolean Indicating whether the source will be
  #                              included when script objects are returned
  # @returns Array of serialized objects indexed using their handle
  registerRequest 'lookup', (refs) -> (body) ->
    objMap = {}
    mapper = mapValue refs
    for handle, ref of body
      objMap[handle] = mapper ref
    objMap

  # The request backtrace returns a backtrace (or stacktrace) from the current
  # execution state. When issuing a request a range of frames can be supplied.
  # The top frame is frame number 0. If no frame range is supplied data for 10
  # frames will be returned.
  #
  # @param fromFrame integer
  # @param toFrame integer?
  # @param bttom boolean? Set to true if the bottom of the stack is requested
  # @returns fromFrame integer
  # @returns toFrame integer
  # @returns totalFrames integer
  # @returns frames StackFrame[]
  registerRequest 'backtrace', (refs) -> ({fromFrame, toFrame, totalFrames, frames}, cb) ->
    # Get all scopes for those frames
    tasks = frames.map (frame) ->
      (cb) ->
        client.scopes { frameNumber: frame.index }, (err, res) ->
          return cb(err) if err?
          for scope in res.scopes
            refs["scope:#{frame.index}:#{scope.index}"] = scope
          cb()

    series tasks, (err) ->
      return cb(err) if err?
      callFrames = frames.map mapFrame(refs)
      cb null, {fromFrame, toFrame, totalFrames, callFrames}

  # The request frame selects a new selected frame and returns information for
  # that. If no frame number is specified the selected frame is returned.
  #
  # @param number integer Frame number (0: top frame)
  # @returns StackFrame
  registerRequest 'frame', mapFrame

  # The request scope returns information on a given scope for a given frame.
  # If no frame number is specified the selected frame is used.
  #
  # @param number Scope number
  # @param frameNumber integer? Optional uses selected frame if missing
  # @returns Scope
  registerRequest 'scope', (refs) -> (scope) ->
    refs["value:#{scope.object.ref}"] = mapValue(refs) scope.object
    mapScope(refs) scope

  # The request scopes returns all the scopes for a given frame. If no frame
  # number is specified the selected frame is returned.
  #
  # @param frameNumber integer? Optional uses selected frame if missing
  # @returns fromScope integer Number of first scope in response
  # @returns toScope integer Number of last scope in response
  # @returns totalScopes integer Total number of scopes for this frame
  # @returns scopes Scope[]
  registerRequest 'scopes', (refs) -> ({fromScope, toScope, totalScopes, scopes}) ->
    scopes = scopes.map (scope) ->
      refs["value:#{scope.object.ref}"] ?= mapValue(refs) scope.object
      mapScope(refs) scope
    return {fromScope, toScope, totalScopes, scopes}

    handles = scopes.map (scope) -> scope.object.ref ? scope.object.handle
    client.lookup { handles, inlineRefs: true }, (err, scopeRefs) ->
      return cb(err) if err?
      refs["value:#{objectId}"] = obj for objectId, obj of scopeRefs
      scopes = scopes.map mapScope(refs)
      cb null, {fromScope, toScope, totalScopes, scopes}

  # The request scripts retrieves active scripts from the VM. An active script
  # is source code from which there is still live objects in the VM. This
  # request will always force a full garbage collection in the VM.
  #
  # The request contains an array of the scripts in the VM. This information
  # includes the relative location of the script within the containing
  # resource.
  #
  # @param types integer? NATIVE=0x1; EXTENSION=0x2; NORMAL=0x4; default 4
  # @param ids integer[] Only return scripts with these ids
  # @param includeSource boolean
  # @param filter (string|integer)? Filter by name or id (search?)
  # @returns Script[]
  registerRequest 'scripts', (refs) -> (scripts) ->
    scripts.map mapScript(refs)

  # The request source retrieves source code for a frame. It returns a number
  # of source lines running from the fromLine to but not including the toLine,
  # that is the interval is open on the "to" end. For example, requesting
  # source from line 2 to 4 returns two lines (2 and 3). Also note that the
  # line numbers are 0 based: the first line is line 0.
  #
  # @param frame integer? Default: selected frame
  # @param fromLine integer? From line within the source, default is line 0
  # @param toLine integer? This line is not included in the result, default is
  #                        the number of lines in the script
  # @returns source string The source code
  # @returns fromLine integer Actual from line within the script
  # @returns toLine integer Actual first not-included line within the script
  # @returns fromPosition integer Actual start position within the scrip
  # @returns toPosition integer Actual end position within the script
  # @returns totalLines integer Total lines in the script
  registerRequest 'source'

  # The request setbreakpoint creates a new break point. This request can be
  # used to set both function and script break points. A function break point
  # sets a break point in an existing function whereas a script break point
  # sets a break point in a named script. A script break point can be set even
  # if the named script is not found.
  #
  # The result of the setbreakpoint request is a response with the number of
  # the newly created break point. This break point number is used in the
  # changebreakpoint and clearbreakpoint requests.
  #
  # @param type function|script|scriptId|scriptRegExp
  # @param target string Function expression or script identification
  # @param line integer Line in script or function
  # @param column integer Character position within the line
  # @param enabled boolean? Initial enabled state, default is true
  # @param condition string? String with break point condition
  # @param ignoreCount integer? How many break point hits to ignore, default 0
  # @returns type function|script
  # @returns breakpoint integer Break point number of the new break point
  registerRequest 'setbreakpoint'

  # The request changebreakpoint changes the status of a break point.
  #
  # @param breakpoint integer Break point id
  # @param enabled boolean? Initial enabled state, default is true
  # @param condition string? String with break point condition
  # @param ignoreCount integer? How many break point hits to ignore, default 0
  registerRequest 'changebreakpoint'

  # The request clearbreakpoint clears a break point.
  #
  # @param breakpoint integer Break point number
  # @returns type function|script
  # @returns breakpoint integer Number of the break point cleared
  registerRequest 'clearbreakpoint'

  registerRequest 'setexceptionbreak'

  registerRequest 'v8flags'

  registerRequest 'version'

  registerRequest 'profile'

  registerRequest 'disconnect'

  registerRequest 'gc'

  registerRequest 'listbreakpoints'

  return client
