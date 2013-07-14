
{series} = require 'async'

RemoteScript = require '../remote-script'

{ErrorObjectFromMessage, RemoteObject} = require '../remote-object'

module.exports = (debugClient) ->
  scopes = (options, cb) ->
    debugClient.sendRequest 'scopes', options, (err, response) ->
      {refMap, body, success, message} = response
      if success
        {fromScope, toScope, totalScopes, scopes} = body
        scopes = scopes.map (scope) ->
          scope.object = RemoteObject({})(refMap) scope.object
          scope.object.objectId = "scope:#{options.frameNumber}:#{scope.index}"
          scope.type = switch scope.type
            when 0 then 'global'
            when 1 then 'local'
            when 2 then 'with'
            when 3 then 'closure'
            when 4 then 'catch'
            else 'unknown'
          scope

        cb null, {fromScope, toScope, totalScopes, scopes}
      else
        cb ErrorObjectFromMessage(options)(refMap) message

  return scopes
