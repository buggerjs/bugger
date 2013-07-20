
TimelineProbe = ->
  toTimeline = require './to_timeline'
  {parseStackTrace} = toTimeline
  nextTimerId = 1
  knownTimers = {}

  console.timeStamp = (message = 'console.timeStamp') ->
    toTimeline 'TimeStamp', data: {message}

  __time = console.time
  console.time = (message) ->
    toTimeline 'Time', data: {message}
    __time.apply console, arguments

  __timeEnd = console.timeEnd
  console.timeEnd = (message) ->
    toTimeline 'TimeEnd', data: {message}
    __timeEnd.apply console, arguments

  timeoutEval = (self, fn, params) ->
    if 'string' is typeof fn
      eval fn
    else
      fn.apply self, params

  __setTimeout = root.setTimeout
  root.setTimeout = (fn, timeout, params...) ->
    timerId = (nextTimerId++).toString()
    wrapFn = ->
      toTimeline 'TimerFire', data: {timerId}
      delete knownTimers[timerId]
      timeoutEval this, fn, arguments

    timerHandle = __setTimeout.call root, wrapFn, timeout, params...
    knownTimers[timerId] = timerHandle
    toTimeline 'TimerInstall', data: {timeout, timerId, singleShot: true}
    timerHandle

  __clearTimeout = root.clearTimeout
  root.clearTimeout = (timerHandle) ->
    timerId = null
    for id, handle of knownTimers
      if handle == timerHandle
        timerId = id
        break

    if timerId?
      delete knownTimers[timerId]
      toTimeline 'TimerRemove', data: {timerId, timeout: timerHandle._idleTimeout}
    __clearTimeout.call root, timerHandle

  __setInterval = root.setInterval
  root.setInterval = (fn, timeout, params...) ->
    timerId = (nextTimerId++).toString()
    wrapFn = ->
      toTimeline 'TimerFire', data: {timerId}
      timeoutEval this, fn, arguments

    timerHandle = __setInterval.call root, wrapFn, timeout, params...
    knownTimers[timerId] = timerHandle
    toTimeline 'TimerInstall', data: {timeout, timerId, singleShot: false}
    timerHandle

  __clearInterval = root.clearInterval
  root.clearInterval = (timerHandle) ->
    timerId = null
    for id, handle of knownTimers
      if handle == timerHandle
        timerId = id
        break

    if timerId?
      toTimeline 'TimerRemove', data: {timerId, timeout: timerHandle._idleTimeout}
    __clearInterval.call root, timerHandle

load = (scriptContext, safe = false) ->
  return if safe
  Timeline = TimelineProbe()

module.exports = {load}
