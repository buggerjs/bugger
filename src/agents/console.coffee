
module.exports = ConsoleAgent =
  enable: (cb) ->
    console.log 'Console#enable'
    cb(null, true)
