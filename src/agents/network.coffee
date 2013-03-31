
_responseContentCache = {}

module.exports = NetworkAgent =
  cacheResponseContent: ({requestId, chunk}) ->
    _responseContentCache[requestId] = (_responseContentCache[requestId] ? '') + chunk.toString()

  getResponseBody: ({requestId}, cb) ->
    cb null, _responseContentCache[requestId].toString(), false
