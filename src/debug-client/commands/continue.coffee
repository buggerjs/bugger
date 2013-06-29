
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  continueCmd = (stepaction, cb) ->
    params = {stepaction}
    if 'function' == typeof stepaction
      cb = stepaction
      params = {}

    debugClient.sendRequest 'continue', params, (err, response) ->

      {refs, body, success, message} = response
      if success
        cb()
      else
        cb ErrorObjectFromMessage({})(refs) message

  return continueCmd
