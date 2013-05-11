# Domain bindings for Canvas
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Canvas = new EventEmitter()

  # Enables Canvas inspection.
  Canvas.enable = ({}, cb) ->
    # Not implemented

  # Disables Canvas inspection.
  Canvas.disable = ({}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  Canvas.dropTraceLog = ({traceLogId}, cb) ->
    # Not implemented

  # Checks if there is any uninstrumented canvas in the inspected page.
  #
  # @returns result boolean 
  Canvas.hasUninstrumentedCanvases = ({}, cb) ->
    # Not implemented

  # Starts (or continues) a canvas frame capturing which will be stopped automatically after the next frame is prepared.
  #
  # @param frameId Network.FrameId? Identifier of the frame containing document whose canvases are to be captured. If omitted, main frame is assumed.
  # @returns traceLogId TraceLogId Identifier of the trace log containing captured canvas calls.
  Canvas.captureFrame = ({frameId}, cb) ->
    # Not implemented

  # Starts (or continues) consecutive canvas frames capturing. The capturing is stopped by the corresponding stopCapturing command.
  #
  # @param frameId Network.FrameId? Identifier of the frame containing document whose canvases are to be captured. If omitted, main frame is assumed.
  # @returns traceLogId TraceLogId Identifier of the trace log containing captured canvas calls.
  Canvas.startCapturing = ({frameId}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  Canvas.stopCapturing = ({traceLogId}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  # @param startOffset integer? 
  # @param maxLength integer? 
  # @returns traceLog TraceLog 
  Canvas.getTraceLog = ({traceLogId, startOffset, maxLength}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  # @param stepNo integer 
  # @returns resourceState ResourceState 
  Canvas.replayTraceLog = ({traceLogId, stepNo}, cb) ->
    # Not implemented

  # @param resourceId ResourceId 
  # @returns resourceInfo ResourceInfo 
  Canvas.getResourceInfo = ({resourceId}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  # @param resourceId ResourceId 
  # @returns resourceState ResourceState 
  Canvas.getResourceState = ({traceLogId, resourceId}, cb) ->
    # Not implemented

  # @param traceLogId TraceLogId 
  # @param resourceId ResourceId 
  Canvas.emit_getResourceState = (params) ->
    notification = {params, method: 'Canvas.getResourceState'}
    @emit 'notification', notification

  # @param traceLogId TraceLogId 
  # @param resourceId ResourceId 
  Canvas.emit_getResourceState = (params) ->
    notification = {params, method: 'Canvas.getResourceState'}
    @emit 'notification', notification

  # # Types
  # Unique resource identifier.
  Canvas.ResourceId = {"id":"ResourceId","type":"string","description":"Unique resource identifier."}
  Canvas.ResourceInfo = {"id":"ResourceInfo","type":"object","properties":[{"name":"id","$ref":"ResourceId"},{"name":"description","type":"string"}]}
  Canvas.ResourceState = {"id":"ResourceState","type":"object","properties":[{"name":"id","$ref":"ResourceId"},{"name":"traceLogId","$ref":"TraceLogId"},{"name":"imageURL","type":"string","optional":true,"description":"Screenshot image data URL."}]}
  Canvas.CallArgument = {"id":"CallArgument","type":"object","properties":[{"name":"description","type":"string"}]}
  Canvas.Call = {"id":"Call","type":"object","properties":[{"name":"contextId","$ref":"ResourceId"},{"name":"functionName","type":"string","optional":true},{"name":"arguments","type":"array","items":{"$ref":"CallArgument"},"optional":true},{"name":"result","$ref":"CallArgument","optional":true},{"name":"isDrawingCall","type":"boolean","optional":true},{"name":"isFrameEndCall","type":"boolean","optional":true},{"name":"property","type":"string","optional":true},{"name":"value","$ref":"CallArgument","optional":true},{"name":"sourceURL","type":"string","optional":true},{"name":"lineNumber","type":"integer","optional":true},{"name":"columnNumber","type":"integer","optional":true}]}
  # Unique trace log identifier.
  Canvas.TraceLogId = {"id":"TraceLogId","type":"string","description":"Unique trace log identifier."}
  Canvas.TraceLog = {"id":"TraceLog","type":"object","properties":[{"name":"id","$ref":"TraceLogId"},{"name":"calls","type":"array","items":{"$ref":"Call"}},{"name":"startOffset","type":"integer"},{"name":"alive","type":"boolean"},{"name":"totalAvailableCalls","type":"number"}]}

  return Canvas
