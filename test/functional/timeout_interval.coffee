
expect = require 'expect.js'
fakeChrome = require '../helpers/fake_chrome'

describe 'Timeline', ->
  it 'sends messages for timeouts and intervals', (done) ->
    fakeChrome([ '--probes=coffee,timeline', 'examples/timeout_interval.coffee' ]).on 'ready', (user) ->
      user.writeFixture 'chrome_connect'
      user.on 'Debugger.paused', ->
        user.write method: 'Debugger.resume'
        user.once 'Timeline.eventRecorded', ({record}) ->
          expect(record.type).to.be 'TimerInstall'
          expect(record.data.timeout).to.be 50
          expect(record.data.singleShot).to.be true
          {timerId} = record.data

          user.once 'Timeline.eventRecorded', ({record}) ->
            # this is the initial setTimeout(fn, 50) firing
            expect(record.type).to.be 'TimerFire'
            expect(record.data.timerId).to.be timerId

            user.once 'Timeline.eventRecorded', ({record}) ->
              expect(record.type).to.be 'TimerInstall'
              expect(record.data.timeout).to.be 20
              expect(record.data.singleShot).to.be false
              {timerId} = record.data

              user.once 'Timeline.eventRecorded', ({record}) ->
                # this is the setInterval(fn, 20) firing
                expect(record.type).to.be 'TimerFire'
                expect(record.data.timerId).to.be timerId

                # next the interval is cleared
                user.once 'Timeline.eventRecorded', ({record}) ->
                  expect(record.type).to.be 'TimerRemove'
                  expect(record.data.timerId).to.be timerId
                  done()
