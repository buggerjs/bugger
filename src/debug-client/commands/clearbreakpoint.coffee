
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  clearbreakpoint = (breakpointId, cb) ->
    params = {breakpoint: breakpointId}
    debugClient.sendRequest 'clearbreakpoint', params, (err, response) ->

      {refs, body, success, message} = response
      if success
        cb null, { breakpointId: body.breakpoint }
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return clearbreakpoint
