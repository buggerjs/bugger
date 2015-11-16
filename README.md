# bugger

[![Build Status](https://travis-ci.org/buggerjs/bugger.png)](https://travis-ci.org/buggerjs/bugger)

**Warning: Experimental**

`bugger` provides Chrome Devtools bindings for node.
It integrates tightly with Chrome which means two things:

* It attempts to fully support the usual Devtools experience, including workspaces and profiling tools.
* It may break at any moment because Chrome moves fast.

## Installation

```bash
npm install -g bugger
```

## Usage

### Start the script process

Start `example/alive.js` in debug mode:

```sh
bugger example/alive.js
```

Pass parameters to the script:

```sh
# This will be interpreted as a port paramter for alive.js
bugger example/alive.js --port=3000
# This will be interpreted as a port paramter for bugger itself
bugger --port=3000 example/alive.js
```

Pass V8 options (or advanced node options):

```sh
node --trace_gc $(which bugger) example/alive.js
```

### Open the devtools

The correct URL will be written to the output. It should look similar to this:

chrome-devtools://devtools/bundled/devtools.html?ws=127.0.0.1:8058/websocket

You can also open `chrome://inspect` if you started Chrome with `--remote-debugging-targets=localhost:8058`.
The process should pop up on that page almost immediately.

## Options:

* `-v, --version`: Print version information
* `-h, --help`: Show usage help
* `-p, --port`: The devtools protocol port to use, default: 8058
* `-b, --brk`: Pause on the first line of the script

## Features

### Console Tab

- Basic support for console API
- Evalute expressions in the console
- Fully featured repl when not paused (including require)

### Sources Tab

- Step-by-step debugging
- Variable introspection
- Live edit the running JavaScript code and persist it using workspaces (really just a Devtools feature)
- Break on [uncaught] exception
- Uses existing source maps (e.g. created via `babel --source-maps` or `coffee --map`)

#### Known Issues

- For `babel-core/register` and `coffee-script/register`, editing the files doesn't work (potentially a won't fix)

### Network Tab

- Monitor outgoing http(s) requests your script does
- Timing of requests, including connect times etc.

### Timeline Tab

- GC events
- Basic heap usage graphs

#### Known Issues

- The timeline tab doesn't do anything useful right now (e.g. `console.{time, timeEnd, timeStamp}`, network request and heap usage reporting aren't working). Profiling data is collected but not really displayed.

### Profiles Tab

- Heap snapshots and CPU profiles (Profiles tab)
- Track heap allocations

## Kudos to...

### ...the original projects

bugger was heavily inspired by [node-inspector](https://github.com/dannycoates/node-inspector) and
[nodebug](https://github.com/billyzkid/nodebug).

## Reference links

- https://chromium.googlesource.com/chromium/blink.git
- http://chromedevtools.github.io/debugger-protocol-viewer/Debugger/
- https://github.com/nodejs/node
