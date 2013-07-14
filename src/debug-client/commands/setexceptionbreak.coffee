
{series} = require 'async'

RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  setexceptionbreak = (options, cb) ->
    debugClient.sendRequest 'setexceptionbreak', options, (err, response) ->
      {refs, body, success, message} = response
      if success
        cb
        # cb null, {}
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return setexceptionbreak
