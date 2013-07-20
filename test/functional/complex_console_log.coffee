
expect = require 'expect.js'
fakeChrome = require '../helpers/fake_chrome'

describe 'Console', ->
  it 'forwards complex log calls', (done) ->
    fakeChrome([ 'examples/complex_console_log.coffee' ]).on 'ready', (user) ->
      user.writeFixture 'chrome_connect'
      user.on 'Debugger.paused', ->
        user.write method: 'Debugger.resume'
        user.once 'Console.messageAdded', ({message}) ->
          expect(message.parameters).to.eql [ { type: 'string', value: 'ok\n' } ]
          expect(message.level).to.be 'log'
          user.once 'Console.messageAdded', ({message}) ->
            expect(message.level).to.be 'log'
            expect(message.parameters).to.eql [
              { type: 'string', value: 'str' },
              { type: 'number', value: 44 },
              { type: 'object', subtype: 'array', objectId: 'console:_log1:[1]', description: 'Array[3]' },
              { type: 'object', objectId: 'console:_log1:[2]', description: 'Object' }
            ]
            done()
