
module.exports = (debugClient) ->
  {
    evaluate: require('./evaluate')(debugClient)
    scripts: require('./scripts')(debugClient)
    backtrace: require('./backtrace')(debugClient)
    scopes: require('./scopes')(debugClient)
    setexceptionbreak: require('./setexceptionbreak')(debugClient)
    lookup: require('./lookup')(debugClient)
  }
