
module.exports = (debugClient) ->
  {
    evaluate: require('./evaluate')(debugClient)
    scripts: require('./scripts')(debugClient)
    backtrace: require('./backtrace')(debugClient)
    scopes: require('./scopes')(debugClient)
    continue: require('./continue')(debugClient)
    suspend: require('./suspend')(debugClient)
    setbreakpoint: require('./setbreakpoint')(debugClient)
    clearbreakpoint: require('./clearbreakpoint')(debugClient)
    setexceptionbreak: require('./setexceptionbreak')(debugClient)
    lookup: require('./lookup')(debugClient)
    changelive: require('./changelive')(debugClient)
  }
