
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  changelive = ({scriptId, scriptSource, preview}, cb) ->
    params =
      script_id: scriptId
      preview_only: preview
      new_source: scriptSource

    debugClient.sendRequest 'changelive', params, (err, response) ->
      {refMap, body, success, message} = response
      if success
        cb null, body
      else
        cb ErrorObjectFromMessage({})(refMap) message

  return changelive
