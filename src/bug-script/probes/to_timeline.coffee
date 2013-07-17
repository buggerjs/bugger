
module.exports = toTimeline = (type, record) ->
  record.type = type
  record.startTime ?= Date.now()
  record.endTime ?= Date.now()
  record.usedHeapSize = process.memoryUsage().heapUsed
  process.send { method: 'Timeline.emit_eventRecorded', record }
