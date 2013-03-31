
http = require 'http'

console.error 'Use mkReq (global) to make requests'

root.mkReq = ->
  http.get('http://www.google.com/?ncd=1', (res) ->
    console.log "Got response: #{res.statusCode}"
  ).on('error', (e) ->
    console.log "Got error: #{e.message}"
  )

setTimeout( ->
  console.log 'Timed out'
1000000000)
