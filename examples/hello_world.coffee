# A very simple example, made to have a minimal callstack
# and one local variable
sayHelloWorld = ->
  setTimeout ->
    msg = 'Hello World'
    console.log msg

unless module.parent?
  do sayHelloWorld

module.exports = sayHelloWorld
