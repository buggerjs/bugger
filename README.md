# bugger

[![Build Status](https://travis-ci.org/jkrems/bugger.png)](https://travis-ci.org/jkrems/bugger) 
[![NPM version](https://badge.fury.io/js/bugger.png)](https://npmjs.org/package/bugger)

**Warning: Experimental**

## Installation

```
(sudo) npm install -g bugger
```

## Usage

### Start the script process

Debug runner for nodejs modules: `bugger examples/simple.js`

Load coffee-script modules: `bugger examples/http_network.coffee`

Pass parameters: `bugger examples/server.js -- --port=3000`

### Open the devtools

chrome-devtools://devtools/devtools.html?ws=127.0.0.1:8058/websocket

## Options:

* `-h`, `--help`, `-v`, `--version` do what you'd expect them to do
* `--no-brk` prevents a breakpoint to be added on the first line of the script
* `--webhost`, `--webport` specifiy where the webserver with inspector will be listening

## Status and warnings

### What is working
* Step-by-step debugging
* SourceMaps for coffee-script
* Variable introspection
* stdout of the process is forwarded to console.log
* Evalute expressions in the console
* Monitor outgoing http(s) requests your script does (Network tab) (not in 0.5.x)
* Pressing "Record" on the Timeline-tab will record memory usage stats (for a gotcha see below) (not in 0.5.x)
* Live edit the running JavaScript code (not in 0.5.x)

### What is missing
* Profiling in general
* Better usage of the Events/Timeline section
* Decision whether the "Resources"-tab makes any sense
* Support for cluster/fork - maybe consider those kind-of (web) workers..?

### What is hacked and/or broken
* `require` doesn't work in the console, it maybe should be more repl-like
* LiveEdit is only working for the compiled javascripts, not for the source mapped files. This
  appears to be a limitation of the WebKit developer tools.
* Memory usage monitoring is running inside of the script thread. Maybe it would be better to
  externalize this (memory stats should be available to the debug/bugger process).

## Kudos to...

### ...the original projects

bugger was heavily inspired by [node-inspector](https://github.com/dannycoates/node-inspector) and
[nodebug](https://github.com/billyzkid/nodebug). Unfortunately both those projects are pretty
outdated and also I was on vacation and had way too much time.

### WebKit inspector

bugger uses the Chrome developer tools as it's frontend.

## Reference links

- https://svn.webkit.org/repository/webkit/trunk/Source/WebCore/inspector
- https://developers.google.com/chrome-developer-tools/docs/protocol/1.0
- https://code.google.com/p/v8/wiki/DebuggerProtocol
