
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  suspend = (cb) ->
    debugClient.sendRequest 'suspend', {}, (err, response) ->

      {refs, body, success, message} = response
      if success
        cb()
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return suspend
