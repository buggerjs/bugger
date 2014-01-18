# Domain bindings for Page
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Page = new EventEmitter()

  fakeMainFrameId = 'bugger-main-frame'
  fakeLoaderId = 'bugger-loader-id'

  # Enables page domain notifications.
  Page.enable = ({}, cb) ->
    # {"name":"securityOrigin","type":"string","description":"Frame document's security origin."},{"name":"mimeType","type":"string","description":"Frame document's mimeType as determined by the browser."}],"hidden":true}
    frame = {
      id: fakeMainFrameId
      loaderId: fakeLoaderId
      url: '/'
      securityOrigin: '/'
      mimeType: 'text/javascript'
    }
    Page.emit_frameNavigated {frame}
    cb null, result: true

  # Disables page domain notifications.
  Page.disable = ({}, cb) ->
    # Not implemented

  # @param scriptSource string 
  # @returns identifier ScriptIdentifier Identifier of the added script.
  Page.addScriptToEvaluateOnLoad = ({scriptSource}, cb) ->
    # Not implemented

  # @param identifier ScriptIdentifier 
  Page.removeScriptToEvaluateOnLoad = ({identifier}, cb) ->
    # Not implemented

  # Reloads given page optionally ignoring the cache.
  #
  # @param ignoreCache boolean? If true, browser cache is ignored (as if the user pressed Shift+refresh).
  # @param scriptToEvaluateOnLoad string? If set, the script will be injected into all frames of the inspected page after reload.
  # @param scriptPreprocessor string? Script body that should evaluate to function that will preprocess all the scripts before their compilation.
  Page.reload = ({ignoreCache, scriptToEvaluateOnLoad, scriptPreprocessor}, cb) ->
    # Not implemented

  # Navigates current page to the given URL.
  #
  # @param url string URL to navigate the page to.
  Page.navigate = ({url}, cb) ->
    # Not implemented

  # Returns all browser cookies. Depending on the backend support, will either return detailed cookie information in the <code>cookie</code> field or string cookie representation using <code>cookieString</code>.
  #
  # @returns cookies Cookie[] Array of cookie objects.
  # @returns cookiesString string document.cookie string representation of the cookies.
  Page.getCookies = ({}, cb) ->
    # Not implemented

  # Deletes browser cookie with given name, domain and path.
  #
  # @param cookieName string Name of the cookie to remove.
  # @param url string URL to match cooke domain and path.
  Page.deleteCookie = ({cookieName, url}, cb) ->
    # Not implemented

  # Returns present frame / resource tree structure.
  #
  # @returns frameTree FrameResourceTree Present frame / resource tree structure.
  Page.getResourceTree = ({}, cb) ->
    # Not implemented

  # Returns content of the given resource.
  #
  # @param frameId Network.FrameId Frame id to get resource for.
  # @param url string URL of the resource to get content for.
  # @returns content string Resource content.
  # @returns base64Encoded boolean True, if content was served as base64.
  Page.getResourceContent = ({frameId, url}, cb) ->
    # Not implemented

  # Searches for given string in resource content.
  #
  # @param frameId Network.FrameId Frame id for resource to search in.
  # @param url string URL of the resource to search in.
  # @param query string String to search for.
  # @param caseSensitive boolean? If true, search is case sensitive.
  # @param isRegex boolean? If true, treats string parameter as regex.
  # @returns result SearchMatch[] List of search matches.
  Page.searchInResource = ({frameId, url, query, caseSensitive, isRegex}, cb) ->
    # Not implemented

  # Searches for given string in frame / resource tree structure.
  #
  # @param text string String to search for.
  # @param caseSensitive boolean? If true, search is case sensitive.
  # @param isRegex boolean? If true, treats string parameter as regex.
  # @returns result SearchResult[] List of search results.
  Page.searchInResources = ({text, caseSensitive, isRegex}, cb) ->
    # Not implemented

  # Sets given markup as the document's HTML.
  #
  # @param frameId Network.FrameId Frame id to set HTML for.
  # @param html string HTML content to set.
  Page.setDocumentContent = ({frameId, html}, cb) ->
    # Not implemented

  Page.canScreencast = ({}, cb) ->
    cb null, result: false

  # Checks whether <code>setDeviceMetricsOverride</code> can be invoked.
  #
  # @returns result boolean If true, <code>setDeviceMetricsOverride</code> can safely be invoked on the agent.
  Page.canOverrideDeviceMetrics = ({}, cb) ->
    cb null, result: false

  # Overrides the values of device screen dimensions (window.screen.width, window.screen.height, window.innerWidth, window.innerHeight, and "device-width"/"device-height"-related CSS media query results) and the font scale factor.
  #
  # @param width integer Overriding width value in pixels (minimum 0, maximum 10000000). 0 disables the override.
  # @param height integer Overriding height value in pixels (minimum 0, maximum 10000000). 0 disables the override.
  # @param fontScaleFactor number Overriding font scale factor value (must be positive). 1 disables the override.
  # @param fitWindow boolean Whether a view that exceeds the available browser window area should be scaled down to fit.
  Page.setDeviceMetricsOverride = ({width, height, fontScaleFactor, fitWindow}, cb) ->
    # Not implemented

  # Requests that backend shows paint rectangles
  #
  # @param result boolean True for showing paint rectangles
  Page.setShowPaintRects = ({result}, cb) ->
    # Not implemented

  # Tells if backend supports debug borders on layers
  #
  # @returns show boolean True if the debug borders can be shown
  Page.canShowDebugBorders = ({}, cb) ->
    cb null, result: false

  # Requests that backend shows debug borders on layers
  #
  # @param show boolean True for showing debug borders
  Page.setShowDebugBorders = ({show}, cb) ->
    # Not implemented

  # Tells if backend supports a FPS counter display
  #
  # @returns show boolean True if the FPS count can be shown
  Page.canShowFPSCounter = ({}, cb) ->
    cb null, result: false

  # Requests that backend shows the FPS counter
  #
  # @param show boolean True for showing the FPS counter
  Page.setShowFPSCounter = ({show}, cb) ->
    # Not implemented

  # Tells if backend supports continuous painting
  #
  # @returns value boolean True if continuous painting is available
  Page.canContinuouslyPaint = ({}, cb) ->
    cb null, result: false

  # Requests that backend enables continuous painting
  #
  # @param enabled boolean True for enabling cointinuous painting
  Page.setContinuousPaintingEnabled = ({enabled}, cb) ->
    # Not implemented

  # Determines if scripts can be executed in the page.
  #
  # @returns result allowed|disabled|forbidden Script execution status: "allowed" if scripts can be executed, "disabled" if script execution has been disabled through page settings, "forbidden" if script execution for the given page is not possible for other reasons.
  Page.getScriptExecutionStatus = ({}, cb) ->
    # Not implemented

  # Switches script execution in the page.
  #
  # @param value boolean Whether script execution should be disabled in the page.
  Page.setScriptExecutionDisabled = ({value}, cb) ->
    # Not implemented

  # Overrides the Geolocation Position or Error.
  #
  # @param latitude number? Mock longitude
  # @param longitude number? Mock latitude
  # @param accuracy number? Mock accuracy
  Page.setGeolocationOverride = ({latitude, longitude, accuracy}, cb) ->
    # Not implemented

  # Clears the overriden Geolocation Position and Error.
  Page.clearGeolocationOverride = ({}, cb) ->
    # Not implemented

  # Checks if Geolocation can be overridden.
  #
  # @returns result boolean True if browser can ovrride Geolocation.
  Page.canOverrideGeolocation = ({}, cb) ->
    cb null, result: false

  # Overrides the Device Orientation.
  #
  # @param alpha number Mock alpha
  # @param beta number Mock beta
  # @param gamma number Mock gamma
  Page.setDeviceOrientationOverride = ({alpha, beta, gamma}, cb) ->
    # Not implemented

  # Clears the overridden Device Orientation.
  Page.clearDeviceOrientationOverride = ({}, cb) ->
    # Not implemented

  # Check the backend if Web Inspector can override the device orientation.
  #
  # @returns result boolean If true, <code>setDeviceOrientationOverride</code> can safely be invoked on the agent.
  Page.canOverrideDeviceOrientation = ({}, cb) ->
    cb null, result: false

  # Toggles mouse event-based touch event emulation.
  #
  # @param enabled boolean Whether the touch event emulation should be enabled.
  Page.setTouchEmulationEnabled = ({enabled}, cb) ->
    # Not implemented

  # Emulates the given media for CSS media queries.
  #
  # @param media string Media type to emulate. Empty string disables the override.
  Page.setEmulatedMedia = ({media}, cb) ->
    # Not implemented

  # Indicates the visibility of compositing borders.
  #
  # @returns result boolean If true, compositing borders are visible.
  Page.getCompositingBordersVisible = ({}, cb) ->
    # Not implemented

  # Controls the visibility of compositing borders.
  #
  # @param visible boolean True for showing compositing borders.
  Page.setCompositingBordersVisible = ({visible}, cb) ->
    # Not implemented

  # Capture page screenshot.
  #
  # @returns data string Base64-encoded image data (PNG).
  Page.captureScreenshot = ({}, cb) ->
    # Not implemented

  # Accepts or dismisses a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload).
  #
  # @param accept boolean Whether to accept or dismiss the dialog.
  # @param promptText string? The text to enter into the dialog prompt before accepting. Used only if this is a prompt dialog.
  Page.handleJavaScriptDialog = ({accept, promptText}, cb) ->
    # Not implemented

  # Introduced in Chrome >= 29
  Page.setShowViewportSizeOnResize = ({show, showGrid}, cb) ->
    # Not implemented

  # @param timestamp number 
  Page.emit_domContentEventFired = (params) ->
    notification = {params, method: 'Page.domContentEventFired'}
    @emit 'notification', notification

  # @param timestamp number 
  Page.emit_loadEventFired = (params) ->
    notification = {params, method: 'Page.loadEventFired'}
    @emit 'notification', notification

  # Fired once navigation of the frame has completed. Frame is now associated with the new loader.
  #
  # @param frame Frame Frame object.
  Page.emit_frameNavigated = (params) ->
    notification = {params, method: 'Page.frameNavigated'}
    @emit 'notification', notification

  # Fired when frame has been detached from its parent.
  #
  # @param frameId Network.FrameId Id of the frame that has been detached.
  Page.emit_frameDetached = (params) ->
    notification = {params, method: 'Page.frameDetached'}
    @emit 'notification', notification

  # Fired when frame has started loading.
  #
  # @param frameId Network.FrameId Id of the frame that has started loading.
  Page.emit_frameStartedLoading = (params) ->
    notification = {params, method: 'Page.frameStartedLoading'}
    @emit 'notification', notification

  # Fired when frame has stopped loading.
  #
  # @param frameId Network.FrameId Id of the frame that has stopped loading.
  Page.emit_frameStoppedLoading = (params) ->
    notification = {params, method: 'Page.frameStoppedLoading'}
    @emit 'notification', notification

  # Fired when frame schedules a potential navigation.
  #
  # @param frameId Network.FrameId Id of the frame that has scheduled a navigation.
  # @param delay number Delay (in seconds) until the navigation is scheduled to begin. The navigation is not guaranteed to start.
  Page.emit_frameScheduledNavigation = (params) ->
    notification = {params, method: 'Page.frameScheduledNavigation'}
    @emit 'notification', notification

  # Fired when frame no longer has a scheduled navigation.
  #
  # @param frameId Network.FrameId Id of the frame that has cleared its scheduled navigation.
  Page.emit_frameClearedScheduledNavigation = (params) ->
    notification = {params, method: 'Page.frameClearedScheduledNavigation'}
    @emit 'notification', notification

  # Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) is about to open.
  #
  # @param message string Message that will be displayed by the dialog.
  Page.emit_javascriptDialogOpening = (params) ->
    notification = {params, method: 'Page.javascriptDialogOpening'}
    @emit 'notification', notification

  # Fired when a JavaScript initiated dialog (alert, confirm, prompt, or onbeforeunload) has been closed.
  Page.emit_javascriptDialogClosed = (params) ->
    notification = {params, method: 'Page.javascriptDialogClosed'}
    @emit 'notification', notification

  # Fired when the JavaScript is enabled/disabled on the page
  #
  # @param isEnabled boolean Whether script execution is enabled or disabled on the page.
  Page.emit_scriptsEnabled = (params) ->
    notification = {params, method: 'Page.scriptsEnabled'}
    @emit 'notification', notification

  # # Types
  # Resource type as it was perceived by the rendering engine.
  Page.ResourceType = {"id":"ResourceType","type":"string","enum":["Document","Stylesheet","Image","Font","Script","XHR","WebSocket","Other"],"description":"Resource type as it was perceived by the rendering engine."}
  # Information about the Frame on the page.
  Page.Frame = {"id":"Frame","type":"object","description":"Information about the Frame on the page.","properties":[{"name":"id","type":"string","description":"Frame unique identifier."},{"name":"parentId","type":"string","optional":true,"description":"Parent frame identifier."},{"name":"loaderId","$ref":"Network.LoaderId","description":"Identifier of the loader associated with this frame."},{"name":"name","type":"string","optional":true,"description":"Frame's name as specified in the tag."},{"name":"url","type":"string","description":"Frame document's URL."},{"name":"securityOrigin","type":"string","description":"Frame document's security origin."},{"name":"mimeType","type":"string","description":"Frame document's mimeType as determined by the browser."}],"hidden":true}
  # Information about the Frame hierarchy along with their cached resources.
  Page.FrameResourceTree = {"id":"FrameResourceTree","type":"object","description":"Information about the Frame hierarchy along with their cached resources.","properties":[{"name":"frame","$ref":"Frame","description":"Frame information for this tree item."},{"name":"childFrames","type":"array","optional":true,"items":{"$ref":"FrameResourceTree"},"description":"Child frames."},{"name":"resources","type":"array","items":{"type":"object","properties":[{"name":"url","type":"string","description":"Resource URL."},{"name":"type","$ref":"ResourceType","description":"Type of this resource."},{"name":"mimeType","type":"string","description":"Resource mimeType as determined by the browser."},{"name":"failed","type":"boolean","optional":true,"description":"True if the resource failed to load."},{"name":"canceled","type":"boolean","optional":true,"description":"True if the resource was canceled during loading."},{"name":"sourceMapURL","type":"string","optional":true,"description":"URL of source map associated with this resource (if any)."}]},"description":"Information about frame resources."}],"hidden":true}
  # Search match for resource.
  Page.SearchMatch = {"id":"SearchMatch","type":"object","description":"Search match for resource.","properties":[{"name":"lineNumber","type":"number","description":"Line number in resource content."},{"name":"lineContent","type":"string","description":"Line with match content."}],"hidden":true}
  # Search result for resource.
  Page.SearchResult = {"id":"SearchResult","type":"object","description":"Search result for resource.","properties":[{"name":"url","type":"string","description":"Resource URL."},{"name":"frameId","$ref":"Network.FrameId","description":"Resource frame id."},{"name":"matchesCount","type":"number","description":"Number of matches in the resource content."}],"hidden":true}
  # Cookie object
  Page.Cookie = {"id":"Cookie","type":"object","description":"Cookie object","properties":[{"name":"name","type":"string","description":"Cookie name."},{"name":"value","type":"string","description":"Cookie value."},{"name":"domain","type":"string","description":"Cookie domain."},{"name":"path","type":"string","description":"Cookie path."},{"name":"expires","type":"number","description":"Cookie expires."},{"name":"size","type":"integer","description":"Cookie size."},{"name":"httpOnly","type":"boolean","description":"True if cookie is http-only."},{"name":"secure","type":"boolean","description":"True if cookie is secure."},{"name":"session","type":"boolean","description":"True in case of session cookie."}],"hidden":true}
  # Unique script identifier.
  Page.ScriptIdentifier = {"id":"ScriptIdentifier","type":"string","description":"Unique script identifier.","hidden":true}

  return Page
