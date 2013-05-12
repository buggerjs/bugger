
{EventEmitter} = require 'events'
{readdirSync} = require 'fs'

module.exports = domains = new EventEmitter()

agentContext =
  debugClient: null

loadDomainNames = ->
  readdirSync(__dirname)
  .filter( (f) -> /^[A-Z].*\.js/.test f)
  .map( (f) -> f.replace '.js', '')

domainNames = do loadDomainNames

domains.handle = (request) ->
  {method} = request
  [domain, command] = method.split '.'
  agent = domains[domain]

  unless agent?
    error = new Error "Domain #{domain} not found"
    return domains.emit 'error', error

  unless typeof agent[command] is 'function'
    error = new Error "Unknown command: #{domain}.#{command}"
    return domains.emit 'error', error

  {params, callback} = request
  agent[command] params, callback

domains.unload = ->
  for domain in domainNames
    agent = domains[domain]
    if agent?
      do agent.removeAllListeners
      if typeof agent.disable is 'function'
        agent.disable {}, ->
    delete domains[domain]
  null # for cs

domains.load = ({debugClient}) ->
  do domains.unload
  agentContext = {debugClient}

  for domain in domainNames
    agent = domains[domain] = require("./#{domain}") agentContext
    agent.on 'notification', (notification) ->
      domains.emit 'notification', notification
  null
