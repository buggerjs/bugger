
ProfilerProbe = ->
  # This part is a pretty straight-forward port of the profiling part of
  # https://github.com/c4milo/node-webkit-agent

  v8profiler = require 'v8-profiler'

  Profiler = {}
  HeapProfiler = {}

  isSampling = false
  profilesByType =
    HEAP: {}
    CPU: {}

  HeapProfileType = 'HEAP'
  CPUProfileType  = 'CPU'

  # @returns result boolean
  Profiler.isSampling = ({}, cb) ->
    cb null, result: isSampling

  Profiler.enable = ({}, cb) ->
    cb()

  Profiler.disable = ({}, cb) ->
    cb()

  Profiler.start = ({}, cb) ->
    v8profiler.startProfiling()

    isSampling = true
    process.send
      method: 'Profiler.emit_setRecordingProfile'
      isProfiling: true

    cb()

  Profiler.stop = ({}, cb) ->
    isSampling = false
    profile = v8profiler.stopProfiling()

    profilesByType[CPUProfileType][profile.uid] = profile

    process.send
      method: 'Profiler.emit_addProfileHeader'
      header:
        title: profile.title
        uid: profile.uid
        typeId: CPUProfileType

    process.send
      method: 'Profiler.emit_setRecordingProfile'
      isProfiling: false

    cb()

  # @returns headers ProfileHeader[] 
  Profiler.getProfileHeaders = ({}, cb) ->
    headers = []

    for type, profiles of profilesByType
      for profileId, profile of profiles
        headers.push
          title: profile.title
          uid: profile.uid
          typeId: type

    cb null, {headers}

  # @param uid integer 
  # @returns profile CPUProfile 
  Profiler.getCPUProfile = ({uid}, cb) ->
    profile = profilesByType[CPUProfileType][uid]
    profile.typeId = CPUProfileType

    cb null, profile: {
      title: profile.title
      uid: profile.uid
      typeId: CPUProfileType
      head: profile.getTopDownRoot()
      bottomUpHead: profile.getBottomUpRoot()
    }

  # @param uid integer 
  HeapProfiler.getHeapSnapshot = ({uid}, cb) ->
    snapshot = profilesByType[HeapProfileType][uid]
    chunks = []

    onData = (chunk, size) ->
      # Directly calling addHeapSnapshotChunk does block *something*
      chunks.push chunk.toString()

    onEnd = ->
      for chunk in chunks
        process.send
          method: 'HeapProfiler.emit_addHeapSnapshotChunk'
          uid: snapshot.uid
          chunk: chunk

      process.send
        method: 'HeapProfiler.emit_finishHeapSnapshot'
        uid: snapshot.uid

      cb null, profile: {
        title: snapshot.title
        uid: snapshot.uid
        typeId: HeapProfileType
      }

    snapshot.serialize {onData, onEnd}

  # @param uid integer 
  Profiler.getHeapSnapshot = ({uid}, cb) ->
    console.log 'Profiler.getHeapSnapshot'
    # Not implemented

  # @param type string 
  # @param uid integer 
  Profiler.removeProfile = ({type, uid}, cb) ->
    if profilesByType[type][uid]?
      delete profilesByType[type][uid]
    cb()

  Profiler.clearProfiles = ({}, cb) ->
    # profilesByType.HEAP = {}
    profilesByType.CPU = {}
    # v8profiler.deleteAllSnapshots()
    v8profiler.deleteAllProfiles()
    cb()

  # @param reportProgress boolean? If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
  HeapProfiler.takeHeapSnapshot = ({reportProgress}, cb) ->
    snapshot = v8profiler.takeSnapshot (done, total) ->
      method = 'HeapProfiler.emit_reportHeapSnapshotProgress'
      process.send {method, done, total}

    profilesByType[HeapProfileType][snapshot.uid] = snapshot

    process.send
      method: 'HeapProfiler.emit_addProfileHeader'
      header:
        title: snapshot.title
        uid: snapshot.uid
        typeId: HeapProfileType

    cb()

  # @param reportProgress boolean? If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
  Profiler.takeHeapSnapshot = ({reportProgress}, cb) ->
    console.log 'Profiler.takeHeapSnapshot'
    # Not implemented

  # @param objectId HeapSnapshotObjectId 
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @returns result Runtime.RemoteObject Evaluation result.
  Profiler.getObjectByHeapObjectId = ({objectId, objectGroup}, cb) ->
    console.log 'Profiler.getObjectByHeapObjectId'
    # Not implemented

  # @param objectId Runtime.RemoteObjectId Identifier of the object to get heap object id for.
  # @returns heapSnapshotObjectId HeapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
  Profiler.getHeapObjectId = ({objectId}, cb) ->
    console.log 'Profiler.getHeapObjectId'
    # Not implemented

  {Profiler, HeapProfiler}

load = (scriptContext, safe = false) ->
  return if safe
  agents = ProfilerProbe()

  process.on 'message', (message) ->
    if message.type == 'forward_req'
      {command, seq} = message
      [domain, method] = command.split '.'
      return unless domain in [ 'Profiler', 'HeapProfiler' ]

      [domain, method] = message.command.split '.'
      agents[domain][method] message.params, (err, data) ->
        response = { command, request_seq: seq, type: 'forward_res' }
        if err?
          response.error = message: err.message, code: err.code, type: err.type
        else
          response.data = data
        
        process.send response

module.exports = {load}
