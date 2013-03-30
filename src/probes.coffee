
loadProbes = (probes = ['network']) ->
  probes.forEach (probeName) ->
    require "./probes/#{probeName}"

class Probe
  constructor: (namespace) ->
    process.on 'message', (message) =>
      if message.method
        [agent, fnName] = message.method.split '.'
        if agent is namespace and fnName?
          this[fnName](message, () ->
            if message.callbackRef?
              process.send { method: 'refCallback', callbackRef: message.callbackRef, args: Array.prototype.slice.call(arguments) }
          )

module.exports = {loadProbes, Probe}
