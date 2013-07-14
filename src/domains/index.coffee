
{EventEmitter} = require 'events'
{readdirSync} = require 'fs'

module.exports = domains = new EventEmitter()

agentContext =
  debugClient: null
  forked: null

loadDomainNames = ->
  readdirSync(__dirname)
  .filter( (f) -> /^[A-Z].*\.js/.test f)
  .map( (f) -> f.replace '.js', '')

domainNames = do loadDomainNames

domains.handle = (request) ->
  {method, params, callback} = request
  [domain, command] = method.split '.'
  agent = domains[domain]
  params ?= {}

  unless agent?
    error = new Error "Domain #{domain} not found"
    return domains.emit 'error', error

  unless typeof agent[command] is 'function'
    paramHint = Object.keys(params ? {}).join(', ')
    error = new Error "Unknown command: #{domain}.#{command}(#{paramHint})"
    return domains.emit 'error', error

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

domains.load = (agentContext) ->
  do domains.unload

  for domain in domainNames
    agent = domains[domain] = require("./#{domain}") agentContext
    agent.on 'notification', (notification) ->
      domains.emit 'notification', notification
  null
