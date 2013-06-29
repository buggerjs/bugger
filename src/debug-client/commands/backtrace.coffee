
{series} = require 'async'

RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

functionName = (func) ->
  if !!func.name
    func.name
  else
    func.inferredName

mapFrame = (refs) -> (rawFrame) ->
  {
    callFrameId: rawFrame.index.toString()
    functionName: functionName rawFrame.func
    location:
      scriptId: rawFrame.func.scriptId.toString()
      lineNumber: rawFrame.line
      columnNumber: rawFrame.column
    scopeChain: rawFrame.scopes.map (scope) ->
      refs["scope:#{rawFrame.index}:#{scope.index}"]
  }

module.exports = (debugClient) ->
  backtrace = (options, cb) ->
    debugClient.sendRequest 'backtrace', options, (err, response) ->
      {refs, body, success, message} = response
      if success
        {fromFrame, toFrame, totalFrames, frames} = body
        frames = [] unless Array.isArray frames

        tasks = frames.map (frame) ->
          (cb) ->
            debugClient.commands.scopes { frameNumber: frame.index }, (err, res) ->
              return cb(err) if err?
              for scope in res.scopes
                refs["scope:#{frame.index}:#{scope.index}"] = scope
              cb()

        series tasks, (err) ->
          return cb(err) if err?
          callFrames = frames.map mapFrame(refs)
          cb null, {fromFrame, toFrame, totalFrames, callFrames}
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return backtrace
