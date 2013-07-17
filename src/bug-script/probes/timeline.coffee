
TimelineProbe = ->
  timerStarts = {}

  console.timeStamp = (message = 'console.timeStamp') ->
    process.send
      method: 'Timeline.emit_eventRecorded'
      record:
        type: 'TimeStamp'
        startTime: Date.now()
        data: {message}

  __time = console.time
  console.time = (message) ->
    startTime = timerStarts[message] = Date.now()
    process.send
      method: 'Timeline.emit_eventRecorded'
      record:
        type: 'Time'
        startTime: startTime
        data: {message}
    __time.apply console, arguments

  __timeEnd = console.timeEnd
  console.timeEnd = (message) ->
    startTime = timerStarts[message]
    process.send
      method: 'Timeline.emit_eventRecorded'
      record:
        type: 'TimeEnd'
        startTime: Date.now()
        data: {message}
    __timeEnd.apply console, arguments

load = (scriptContext, safe = false) ->
  return if safe
  Timeline = TimelineProbe()

module.exports = {load}
