# bugger

[![Build Status](https://travis-ci.org/buggerjs/bugger.png)](https://travis-ci.org/buggerjs/bugger)

**Warning: Experimental**

## Installation

```bash
npm install -g bugger
```

## Usage

### Start the script process

Debug runner for nodejs modules:

```sh
bugger examples/alive.js
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
