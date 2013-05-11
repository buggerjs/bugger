# Domain bindings for Memory
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Memory = new EventEmitter()

  # @returns documents integer 
  # @returns nodes integer 
  # @returns jsEventListeners integer 
  Memory.getDOMCounters = ({}, cb) ->
    # Not implemented

  # @param chunk HeapSnapshotChunk A chunk of the serialized the snapshot.
  Memory.emit_addNativeSnapshotChunk = (params) ->
    notification = {params, method: 'Memory.addNativeSnapshotChunk'}
    @emit 'notification', notification

  # # Types
  Memory.MemoryBlock = {"id":"MemoryBlock","type":"object","properties":[{"name":"size","type":"number","optional":true,"description":"Size of the block in bytes if available"},{"name":"name","type":"string","description":"Unique name used to identify the component that allocated this block"},{"name":"children","type":"array","optional":true,"items":{"$ref":"MemoryBlock"}}]}
  Memory.HeapSnapshotChunk = {"id":"HeapSnapshotChunk","type":"object","properties":[{"name":"strings","type":"array","items":{"type":"string"},"description":"An array of strings that were found since last update."},{"name":"nodes","type":"array","items":{"type":"integer"},"description":"An array of nodes that were found since last update."},{"name":"edges","type":"array","items":{"type":"integer"},"description":"An array of edges that were found since last update."},{"name":"baseToRealNodeId","type":"array","items":{"type":"integer"},"description":"An array of integers for nodeId remapping. Even nodeId has to be mapped to the following odd nodeId."}]}

  return Memory
