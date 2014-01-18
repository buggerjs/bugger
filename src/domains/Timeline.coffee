# Domain bindings for Timeline
{EventEmitter} = require 'events'

module.exports = ({debugClient}) ->
  Timeline = new EventEmitter()

  Timeline.enable = ({}, cb) ->
    cb null, result: true

  # Starts capturing instrumentation events.
  #
  # @param maxCallStackDepth integer? Samples JavaScript stack traces up to <code>maxCallStackDepth</code>, defaults to 5.
  # @param includeDomCounters boolean? Whether DOM counters data should be included into timeline events.
  # @param includeNativeMemoryStatistics boolean? Whether native memory usage statistics should be reported as part of timeline events.
  Timeline.start = ({maxCallStackDepth, includeDomCounters, includeNativeMemoryStatistics}, cb) ->
    # Not implemented

  # Stops capturing instrumentation events.
  Timeline.stop = ({}, cb) ->
    # Not implemented

  # Tells whether timeline agent supports frame instrumentation.
  #
  # @returns result boolean True if timeline supports frame instrumentation.
  Timeline.supportsFrameInstrumentation = ({}, cb) ->
    cb null, result: false

  # Tells whether timeline agent supports main thread CPU utilization instrumentation.
  #
  # @returns result boolean True if timeline supports main thread CPU utilization instrumentation.
  Timeline.canMonitorMainThread = ({}, cb) ->
    cb null, result: false

  # Fired for every instrumentation event while timeline is started.
  #
  # @param record TimelineEvent Timeline event record data.
  Timeline.emit_eventRecorded = (params) ->
    notification = {params, method: 'Timeline.eventRecorded'}
    @emit 'notification', notification

  # # Types
  # Current values of DOM counters.
  Timeline.DOMCounters = {"id":"DOMCounters","type":"object","properties":[{"name":"documents","type":"integer"},{"name":"nodes","type":"integer"},{"name":"jsEventListeners","type":"integer"}],"description":"Current values of DOM counters.","hidden":true}
  # Timeline record contains information about the recorded activity.
  Timeline.TimelineEvent = {"id":"TimelineEvent","type":"object","properties":[{"name":"type","type":"string","description":"Event type."},{"name":"thread","type":"string","optional":true,"description":"If present, identifies the thread that produced the event.","hidden":true},{"name":"data","type":"object","description":"Event data."},{"name":"children","type":"array","optional":true,"items":{"$ref":"TimelineEvent"},"description":"Nested records."},{"name":"counters","$ref":"DOMCounters","optional":true,"hidden":true,"description":"Current values of DOM counters."},{"name":"usedHeapSize","type":"integer","optional":true,"hidden":true,"description":"Current size of JS heap."},{"name":"nativeHeapStatistics","type":"object","optional":true,"hidden":true,"description":"Native heap statistics."}],"description":"Timeline record contains information about the recorded activity."}

  return Timeline
