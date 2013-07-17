
TimelineProbe = ->
  toTimeline = require './to_timeline'

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

load = (scriptContext, safe = false) ->
  return if safe
  Timeline = TimelineProbe()

module.exports = {load}
