
module.exports = callbackWrapper = ({commands}) ->
  callbackBySeq = {}
  lastSeq = 5000

  wrapCallback = (cb) ->
    callbackBySeq[++lastSeq] = cb
    lastSeq

  unwrapCallback = (obj) ->
    cb = callbackBySeq[obj.request_seq]
    return unless cb?
    cb null, obj

  {wrapCallback, unwrapCallback}
