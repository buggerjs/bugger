# bugger

[![Build Status](https://travis-ci.org/buggerjs/bugger.png)](https://travis-ci.org/buggerjs/bugger)

**Warning: Experimental**

## Installation

```bash
npm install -g bugger
```

## Usage

### Start the script process

Debug runner for nodejs modules: `bugger examples/simple.js`

Pass parameters: `bugger examples/server.js --port=3000`

### Open the devtools

The correct URL will be written to the output. It should look similar to this:

chrome-devtools://devtools/bundled/devtools.html?ws=127.0.0.1:8058/websocket

## Options:

* `-h`, `--help`, `-v`, `--version` do what you'd expect them to do
* `--no-brk` prevents a breakpoint to be added on the first line of the script
* `--webhost`, `--webport` specifiy where the webserver with inspector will be listening

## Status and warnings

### What is working
* Step-by-step debugging
* Variable introspection
* stdout of the process is forwarded to console.log
* Evalute expressions in the console
* Monitor outgoing http(s) requests your script does (Network tab)
* Heap snapshots and CPU profiles (Profiles tab)
* Use console.{time, timeEnd, timeStamp}, network request and heap usage reporting (Timeline tab)
* Live edit the running JavaScript code

### What is missing
* Better usage of the Events/Timeline section
* Decision whether the "Resources"-tab makes any sense
* Support for cluster/fork - maybe consider those kind-of (web) workers..?

### What is hacked and/or broken
* LiveEdit is only working for the compiled javascripts, not for the source mapped files.
  This appears to be a limitation of the WebKit developer tools.

## Kudos to...

### ...the original projects

bugger was heavily inspired by [node-inspector](https://github.com/dannycoates/node-inspector) and
[nodebug](https://github.com/billyzkid/nodebug).

### WebKit inspector

bugger uses the Chrome developer tools as its frontend.

## Reference links

- https://svn.webkit.org/repository/webkit/trunk/Source/WebCore/inspector
- https://developers.google.com/chrome-developer-tools/docs/protocol/1.0
- https://code.google.com/p/v8/wiki/DebuggerProtocol
