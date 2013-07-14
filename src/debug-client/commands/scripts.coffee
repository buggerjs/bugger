
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  scripts = (options, cb) ->
    debugClient.sendRequest 'scripts', options, (err, response) ->
      {refs, body, success, message} = response
      if success
        scripts = body.map RemoteScript(refs)
        cb null,  scripts
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return scripts
