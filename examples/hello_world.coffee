# A very simple example, made to have a minimal callstack
# and one local variable
setTimeout ->
  msg = 'Hello World'
  console.log msg
