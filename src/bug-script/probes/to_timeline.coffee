
parseStackTrace = (stackString) ->
  stack = (stackString + '\n').replace(/^\S[^\(]+?[\n$]/gm, '')
  .replace(/^\s+(at eval )?at\s+/gm, '')
  .replace(/^([^\(]+?)([\n$])/gm, '{anonymous}()@$1$2')
  .replace(/^Object.<anonymous>\s*\(([^\)]+)\)/gm, '{anonymous}()@$1')
  .split('\n')
  do stack.pop
  stackTrace = stack.map(
    (line) -> line.match /^(.+) \(([^(]+)\:(\d+)\:(\d+)\)$/
  ).filter(
    (m) -> m?
  ).map(
    ([_, functionName, filename, lineNumber, columnNumber]) ->
      url = 'file://' + filename.replace(/(\\)/g, '/')
      {functionName, url, lineNumber, columnNumber}
  )
  stackTrace.shift()
  stackTrace

module.exports = toTimeline = (type, record) ->
  record.type = type
  record.startTime ?= Date.now()
  record.endTime ?= Date.now()
  record.usedHeapSize = process.memoryUsage().heapUsed
  record.stackTrace ?= parseStackTrace new Error().stack
  process.send { method: 'Timeline.emit_eventRecorded', record }

toTimeline.parseStackTrace = parseStackTrace
