
{series} = require 'async'

RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  scopes = (options, cb) ->
    debugClient.sendRequest 'scopes', options, (err, response) ->
      {refs, body, success, message} = response
      if success
        {fromScope, toScope, totalScopes, scopes} = body
        scopes = scopes.map (scope) -> scope
        cb null, {fromScope, toScope, totalScopes, scopes}
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return scopes
