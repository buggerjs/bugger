
###
Debugger.Scope = {"id":"Scope","type":"object","properties":[
  {"name":"type","type":"string","enum":["global","local","with","closure","catch"],"description":"Scope type."},
  {"name":"object","$ref":"Runtime.RemoteObject","description":"Object representing the scope. For <code>global</code> and <code>with</code> scopes it represents the actual object; for the rest of the scopes, it is artificial transient object enumerating scope variables as its properties."}],
  "description":"Scope description."}
###

scopeType = (type) ->
  switch type
    when 0 then 'global'
    when 1 then 'local'
    when 2 then 'with'
    when 3 then 'closure'
    when 4 then 'catch'

module.exports = (refs) -> (body) ->
  {
    index: body.index
    type: scopeType(body.type)
    object: refs["value:#{body.object.ref}"]
  }
