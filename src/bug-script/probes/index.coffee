
knownProbes = ['./coffee', './network', './profiler', './timeline', './console']

module.exports = (safe = false, filter = null) ->
  if typeof filter == 'string'
    filter = filter.split ','

  unless Array.isArray(filter) && filter.length > 0
    filter = null

  compilers =
    '.js':
      compile: (filename, code) -> { code, map: null }
      compileString: (input) -> input

  scriptContext = { compilers }

  probesToLoad =
    if filter?
      probesToLoad = knownProbes.filter (probe) ->
        filter.indexOf(probe.substr(2)) != -1
    else
      knownProbes

  probesToLoad.forEach (probeModule) ->
    {load} = require probeModule
    load scriptContext, safe

  scriptContext
