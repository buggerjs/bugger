
module.exports = callbackWrapper = ->
  callbackBySeq = {}
  lastSeq = 5000

  wrapCallback = (cb) ->
    callbackBySeq[++lastSeq] = cb
    lastSeq

  unwrapCallback = (obj) ->
    cb = callbackBySeq[obj.request_seq]
    return unless cb?
    cb null, obj

  unwrapWrapped = (obj) ->
    cb = callbackBySeq[obj.request_seq]
    return unless cb?
    cb obj.error, obj.data

  {wrapCallback, unwrapCallback, unwrapWrapped}
