# Domain bindings for HeapProfiler
{EventEmitter} = require 'events'
callbackWrapper = require '../callback-wrapper'

module.exports = ({debugClient, forked}) ->
  HeapProfiler = new EventEmitter()

  {wrapCallback, unwrapWrapped} = callbackWrapper()

  forked.on 'message', (message) ->
    if message.type is 'forward_res'
      {command} = message
      return unless command.substr(0, 13) == 'HeapProfiler.'
      unwrapWrapped message

  forwardMethod = (method) ->
    HeapProfiler[method] = (params, cb) ->
      message =
        type: 'forward_req'
        command: "HeapProfiler.#{method}"
        params: params
        seq: wrapCallback(cb)

      forked.send message

  # @returns result boolean 
  HeapProfiler.hasHeapProfiler = ({}, cb) ->
    console.log 'HeapProfiler.hasHeapProfiler'
    cb null, result: true

  # @returns headers ProfileHeader[] 
  forwardMethod 'getProfileHeaders'

  # @param uid integer 
  forwardMethod 'getHeapSnapshot'

  # @param uid integer 
  forwardMethod 'removeProfile'

  forwardMethod 'clearProfiles'

  # @param reportProgress boolean? If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
  forwardMethod 'takeHeapSnapshot'

  HeapProfiler.collectGarbage = ({}, cb) ->
    # Not implemented

  # @param objectId HeapSnapshotObjectId 
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @returns result Runtime.RemoteObject Evaluation result.
  HeapProfiler.getObjectByHeapObjectId = ({objectId, objectGroup}, cb) ->
    # Not implemented

  # @param objectId Runtime.RemoteObjectId Identifier of the object to get heap object id for.
  # @returns heapSnapshotObjectId HeapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
  HeapProfiler.getHeapObjectId = ({objectId}, cb) ->
    # Not implemented

  # @param header ProfileHeader 
  HeapProfiler.emit_addProfileHeader = (params) ->
    notification = {params, method: 'HeapProfiler.addProfileHeader'}
    @emit 'notification', notification

  # @param uid integer 
  # @param chunk string 
  HeapProfiler.emit_addHeapSnapshotChunk = (params) ->
    notification = {params, method: 'HeapProfiler.addHeapSnapshotChunk'}
    @emit 'notification', notification

  # @param uid integer 
  HeapProfiler.emit_finishHeapSnapshot = (params) ->
    notification = {params, method: 'HeapProfiler.finishHeapSnapshot'}
    @emit 'notification', notification

  HeapProfiler.emit_resetProfiles = (params) ->
    notification = {params, method: 'HeapProfiler.resetProfiles'}
    @emit 'notification', notification

  # @param done integer 
  # @param total integer 
  HeapProfiler.emit_reportHeapSnapshotProgress = (params) ->
    notification = {params, method: 'HeapProfiler.reportHeapSnapshotProgress'}
    @emit 'notification', notification

  # # Types
  # Profile header.
  HeapProfiler.ProfileHeader = {"id":"ProfileHeader","type":"object","description":"Profile header.","properties":[{"name":"title","type":"string","description":"Profile title."},{"name":"uid","type":"integer","description":"Unique identifier of the profile."},{"name":"maxJSObjectId","type":"integer","optional":true,"description":"Last seen JS object Id."}]}
  # Heap snashot object id.
  HeapProfiler.HeapSnapshotObjectId = {"id":"HeapSnapshotObjectId","type":"string","description":"Heap snashot object id."}

  return HeapProfiler
