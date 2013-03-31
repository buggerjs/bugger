
argv = require '../argv'

module.exports = PageAgent =
  getResourceTree: (cb) ->
    # cb(error, mainFramePayload = { childFrames, resources, frame = { mimeType, url, type, id, loaderId, name, securityOrigin } })
    cb null, {
      childFrames: []
      resources: []
      frame:
        mimeType: 'application/javascript'
        url: argv.getAppUrl()
        type: 'script'
        id: 1
        loaderId: 1
        name: 'main'
        securityOrigin: argv.webhost
    }
