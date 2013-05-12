# Use inspector.json to generate agent code
{log} = console
{writeFileSync} = require 'fs'
path = require 'path'

{version, domains} = require '../src/inspector.json'
{major, minor} = version
log "Debugging protocol v#{major}.#{minor}\n"

allTypes = {}

log 'Collecting types'
for domainDef in domains
  {domain, types} = domainDef
  continue unless Array.isArray(types) and types.length
  for type in types
    {id} = type
    fullName = "#{domain}.#{id}"
    allTypes[fullName] = type

log " * Found #{Object.keys(allTypes).length} types\n"

fileFor = (domain, suffix = '.coffee') ->
  path.join __dirname, '..', 'src', 'domains', domain + suffix

getFileHead = (domainCtx) ->
  {domain, types} = domainCtx
  code  = "# Domain bindings for #{domain}\n"
  code += "{EventEmitter} = require 'events'\n\n"
  code += "module.exports = (agentContext) ->\n"
  code += "  #{domain} = new EventEmitter()\n\n"

  code

getTypeString = (param) ->
  return param['$ref'] if param['$ref']?
  if param['type'] is 'array'
    return getTypeString(param.items) + '[]'
  if param['enum']?
    return param['enum'].join('|')
  return param.type if param.type?
  throw param

getCommandCode = (command, domainCtx) ->
  {name, description, parameters, returns} = command
  {domain} = domainCtx
  parameters ?= []
  returns ?= []
  code  = ""
  code += "  # #{description}\n" if description?
  if parameters.length or returns.length
    code += "  #\n" if description?
    for parameter in parameters
      typeStr = getTypeString parameter
      typeStr += '?' if parameter.optional
      code += "  # @param #{parameter.name} #{typeStr} #{parameter.description ? ''}\n"
    for retValue in returns
      typeStr = getTypeString retValue
      typeStr += '?' if retValue.optional
      code += "  # @returns #{retValue.name} #{typeStr} #{retValue.description ? ''}\n"

  fnArrow =
    '({' + parameters.map( (p) -> p.name.replace(/^arguments$/, '$arguments') ).join(', ') + '}, cb) ->'

  code += "  #{domain}.#{name} = #{fnArrow}\n"
  code += "    # Not implemented\n"
  code += "\n"

getEventCode = (anEvent, domainCtx) ->
  {name, description, parameters, returns} = anEvent
  {domain} = domainCtx
  parameters ?= []
  code  = ""
  code += "  # #{description}\n" if description?
  if parameters.length
    code += "  #\n" if description?
    for parameter in parameters
      typeStr = getTypeString parameter
      typeStr += '?' if parameter.optional
      code += "  # @param #{parameter.name} #{typeStr} #{parameter.description ? ''}\n"

  code += "  #{domain}.emit_#{name} = (params) ->\n"
  code += "    notification = {params, method: '#{domain}.#{name}'}\n"
  code += "    @emit 'notification', notification\n"
  code += "\n"

for domainDef in domains
  {domain, commands, events, types} = domainDef
  commands = [] unless Array.isArray commands
  events = [] unless Array.isArray events
  log "#{domain}: #{commands.length} commands and #{events.length} events"

  code = getFileHead domainDef
  for command in commands
    code += getCommandCode command, domainDef

  for anEvent in events
    code += getEventCode anEvent, domainDef

  if types? and types.length
    code += "  # # Types\n"
    for type in types
      code += "  # #{type.description}\n" if type.description?
      code += "  #{domain}.#{type.id} = " + JSON.stringify(type)
      code += "\n"

  code += "\n  return #{domain}\n"

  writeFileSync fileFor(domain), code, 'utf8'

  log " * Done.\n"
