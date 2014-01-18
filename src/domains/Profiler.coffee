# Domain bindings for Profiler
{EventEmitter} = require 'events'
callbackWrapper = require '../callback-wrapper'

module.exports = ({debugClient, forked}) ->
  Profiler = new EventEmitter()

  {wrapCallback, unwrapWrapped} = callbackWrapper()

  forked.on 'message', (message) ->
    if message.type is 'forward_res'
      {command} = message
      return unless command.substr(0, 9) == 'Profiler.'
      unwrapWrapped message

  forwardMethod = (method) ->
    Profiler[method] = (params, cb) ->
      message =
        type: 'forward_req'
        command: "Profiler.#{method}"
        params: params
        seq: wrapCallback(cb)

      forked.send message

  # @returns result boolean 
  Profiler.causesRecompilation = ({}, cb) ->
    cb null, result: false

  # @returns result boolean
  forwardMethod 'isSampling'

  # @returns result boolean 
  Profiler.hasHeapProfiler = ({}, cb) ->
    cb null, result: true

  # @returns result boolean
  forwardMethod 'hasHeapProfiler'

  forwardMethod 'enable'

  forwardMethod 'disable'

  forwardMethod 'start'

  forwardMethod 'stop'

  # @returns headers ProfileHeader[] 
  forwardMethod 'getProfileHeaders'

  # @param uid integer 
  # @returns profile CPUProfile 
  forwardMethod 'getCPUProfile'

  # @param uid integer 
  forwardMethod 'getHeapSnapshot'

  # @param type string 
  # @param uid integer 
  forwardMethod 'removeProfile'

  forwardMethod 'clearProfiles'

  # @param reportProgress boolean? If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
  forwardMethod 'takeHeapSnapshot'

  Profiler.collectGarbage = ({}, cb) ->
    # Not implemented

  Profiler.setSamplingInterval = ({interval}, cb) ->
    cb()

  # @param objectId HeapSnapshotObjectId 
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @returns result Runtime.RemoteObject Evaluation result.
  forwardMethod 'getObjectByHeapObjectId'

  # @param objectId Runtime.RemoteObjectId Identifier of the object to get heap object id for.
  # @returns heapSnapshotObjectId HeapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
  forwardMethod 'getHeapObjectId'

  # @param header ProfileHeader 
  Profiler.emit_addProfileHeader = (params) ->
    notification = {params, method: 'Profiler.addProfileHeader'}
    @emit 'notification', notification

  # @param uid integer 
  # @param chunk string 
  Profiler.emit_addHeapSnapshotChunk = (params) ->
    notification = {params, method: 'Profiler.addHeapSnapshotChunk'}
    @emit 'notification', notification

  # @param uid integer 
  Profiler.emit_finishHeapSnapshot = (params) ->
    notification = {params, method: 'Profiler.finishHeapSnapshot'}
    @emit 'notification', notification

  # @param isProfiling boolean 
  Profiler.emit_setRecordingProfile = (params) ->
    notification = {params, method: 'Profiler.setRecordingProfile'}
    @emit 'notification', notification

  Profiler.emit_resetProfiles = (params) ->
    notification = {params, method: 'Profiler.resetProfiles'}
    @emit 'notification', notification

  # @param done integer 
  # @param total integer 
  Profiler.emit_reportHeapSnapshotProgress = (params) ->
    notification = {params, method: 'Profiler.reportHeapSnapshotProgress'}
    @emit 'notification', notification

  # # Types
  # Profile header.
  Profiler.ProfileHeader = {"id":"ProfileHeader","type":"object","description":"Profile header.","properties":[{"name":"typeId","type":"string","enum":["CPU","CSS","HEAP"],"description":"Profile type name."},{"name":"title","type":"string","description":"Profile title."},{"name":"uid","type":"integer","description":"Unique identifier of the profile."},{"name":"maxJSObjectId","type":"integer","optional":true,"description":"Last seen JS object Id."}]}
  # CPU Profile node. Holds callsite information, execution statistics and child nodes.
  Profiler.CPUProfileNode = {"id":"CPUProfileNode","type":"object","description":"CPU Profile node. Holds callsite information, execution statistics and child nodes.","properties":[{"name":"functionName","type":"string","description":"Function name."},{"name":"url","type":"string","description":"URL."},{"name":"lineNumber","type":"integer","description":"Line number."},{"name":"totalTime","type":"number","description":"Total execution time."},{"name":"selfTime","type":"number","description":"Self time."},{"name":"numberOfCalls","type":"integer","description":"Number of calls."},{"name":"visible","type":"boolean","description":"Visibility."},{"name":"callUID","type":"number","description":"Call UID."},{"name":"children","type":"array","items":{"$ref":"CPUProfileNode"},"description":"Child nodes."},{"name":"id","optional":true,"type":"integer","description":"Unique id of the node."}]}
  # Profile.
  Profiler.CPUProfile = {"id":"CPUProfile","type":"object","description":"Profile.","properties":[{"name":"head","$ref":"CPUProfileNode","optional":true},{"name":"idleTime","type":"number","optional":true},{"name":"samples","optional":true,"type":"array","items":{"type":"integer"},"description":"Ids of samples top nodes."}]}
  # Heap snashot object id.
  Profiler.HeapSnapshotObjectId = {"id":"HeapSnapshotObjectId","type":"string","description":"Heap snashot object id."}

  return Profiler
