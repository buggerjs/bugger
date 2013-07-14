
RemoteScript = require '../remote-script'

{ErrorObjectFromMessage} = require '../remote-object'

module.exports = (debugClient) ->
  setbreakpoint = (options, cb) ->
    {lineNumber, url, urlRegex, columnNumber, condition} = options

    breakpointDesc = { line: lineNumber, column: columnNumber, condition }
    if urlRegex?
      breakpointDesc.type = 'scriptRegExp'
      breakpointDesc.target = urlRegex
    else
      breakpointDesc.type = 'script'
      breakpointDesc.target = url.replace(/^file:\/\//, '')

    debugClient.sendRequest 'setbreakpoint', breakpointDesc, (err, response) ->

      {refs, body, success, message} = response
      if success
        breakpointResponse =
          breakpointId: body.breakpoint.toString()
          locations: body.actual_locations.map (l) ->
            { scriptId: l.script_id.toString(), lineNumber: l.line, columnNumber: l.column }
        cb null, breakpointResponse
      else
        cb ErrorObjectFromMessage(options)(refs) message

  return setbreakpoint
