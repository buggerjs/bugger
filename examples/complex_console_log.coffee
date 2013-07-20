console.log 'ok'
console.log 'str', 44, [ 1, 2, 3 ], some: { nested: 'object' }
setTimeout(
  -> process.exit 0
  50
)
