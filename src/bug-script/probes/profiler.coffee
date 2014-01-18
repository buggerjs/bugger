
ProfilerProbe = ->
  # This part is a pretty straight-forward port of the profiling part of
  # https://github.com/c4milo/node-webkit-agent

  v8profiler = require 'v8-profiler'

  Profiler = {}
  HeapProfiler = {}

  profileStarts = {}

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

  Profiler.start = ({name}, cb) ->
    name ?= ''

    profileStarts[name] = Date.now() / 1000
    v8profiler.startProfiling name

    isSampling = true

    cb()

  Profiler.stop = ({name}, cb) ->
    name ?= ''
    isSampling = false
    profile = v8profiler.stopProfiling name

    profile.startTime = profileStarts[name]
    delete profileStarts[name]
    profile.endTime = Date.now() / 1000

    profilesByType[CPUProfileType][profile.uid] = profile

    withHitCounts = (node) ->
      node.hitCount = node.selfTime
      for child in node.children
        withHitCounts child
      node

    cb null, profile: {
      title: profile.title
      uid: profile.uid
      typeId: CPUProfileType
      head: withHitCounts profile.getTopDownRoot()
      bottomUpHead: withHitCounts profile.getBottomUpRoot()
      startTime: profile.startTime
      endTime: profile.endTime
    }

  # @returns headers ProfileHeader[] 
  HeapProfiler.getProfileHeaders = ({}, cb) ->
    headers = []

    for profileId, profile of profilesByType[HeapProfileType]
      headers.push
        title: profile.title
        uid: profile.uid
        typeId: HeapProfileType

    cb null, {headers}

  # @returns headers ProfileHeader[] 
  Profiler.getProfileHeaders = ({}, cb) ->
    headers = []

    for profileId, profile of profilesByType[CPUProfileType]
      headers.push
        title: profile.title
        uid: profile.uid
        typeId: CPUProfileType

    cb null, {headers}

  # @param uid integer 
  # @returns profile CPUProfile 
  Profiler.getCPUProfile = ({uid}, cb) ->
    profile = profilesByType[CPUProfileType][uid]
    profile.typeId = CPUProfileType

    withHitCounts = (node) ->
      node.hitCount = node.selfTime
      for child in node.children
        withHitCounts child
      node

    cb null, profile: {
      title: profile.title
      uid: profile.uid
      typeId: CPUProfileType
      head: withHitCounts profile.getTopDownRoot()
      bottomUpHead: withHitCounts profile.getBottomUpRoot()
      startTime: profile.startTime
      endTime: profile.endTime
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

      cb null, profile: {
        title: snapshot.title
        uid: snapshot.uid
        typeId: HeapProfileType
      }

    snapshot.serialize {onData, onEnd}

  # @param uid integer 
  Profiler.getHeapSnapshot = ({uid}, cb) ->
    # Not implemented

  # @param uid integer 
  HeapProfiler.removeProfile = ({uid}, cb) ->
    if profilesByType[HeapProfileType][uid]?
      delete profilesByType[HeapProfileType][uid]
    cb()

  HeapProfiler.clearProfiles = ({}, cb) ->
    profilesByType.HEAP = {}
    v8profiler.deleteAllSnapshots()

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
    # Not implemented

  # @param objectId HeapSnapshotObjectId 
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @returns result Runtime.RemoteObject Evaluation result.
  Profiler.getObjectByHeapObjectId = ({objectId, objectGroup}, cb) ->
    # Not implemented

  # @param objectId Runtime.RemoteObjectId Identifier of the object to get heap object id for.
  # @returns heapSnapshotObjectId HeapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
  Profiler.getHeapObjectId = ({objectId}, cb) ->
    # Not implemented

  {Profiler, HeapProfiler}

load = (scriptContext, safe = false) ->
  return if safe
  agents = ProfilerProbe()

  root.profile ?= console.profile ?= (name) ->
    agents['Profiler'].start {name}, ->

  root.profileEnd ?= console.profileEnd ?= (name) ->
    agents['Profiler'].stop {name}, ->

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
