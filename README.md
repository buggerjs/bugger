# bugger

**Warning: Experimental**

## Installation

```
(sudo) npm install -g bugger
```

## Usage

Debug runner for nodejs modules: `bugger my_module.js`

Generally the same rule apply for the script argument as for require'ing a nodejs module. The
only difference for convenience reasons is that "path/to/module" is interpreted as
"./path/to/module" where the path is relative to the current working directory. bugger currently
supports loading javascript and coffee-script modules.

## Options:

* `-h`, `--help`, `-v`, `--version` do what you'd expect them to do
* `--no-brk` prevents a breakpoint to be added on the first line of the script
* `--chrome` opens Chrome with the correct URL to start debugging
* `--webhost`, `--webport` specifiy where the webserver with inspector will be listening

## Status and warnings

### What is working
* Step-by-step debugging
* SourceMaps for coffee-script
* Variable introspection
* stdout of the process is forwarded to console.log
* Evalute expressions in the console
* Monitor outgoing http(s) requests your script does (Network tab)
* Pressing "Record" on the Timeline-tab will record memory usage stats (for a gotcha see below)

### What is missing
* Profiling in general
* Incoming network requests - should they appear in the Network-tab as well? Would that be
  confusing when combined with outgoing requests?
* Better usage of the Events/Timeline section
* Decision whether the "Resources"-tab makes any sense
* stderr to console.error forwarding
* Support for cluster/fork - maybe consider those kind-of (web) workers..?

### What is hacked and/or broken
* `require` doesn't work in the console, it maybe should be more repl-like
* A lot of stuff is just dumped to console.log - proper logging would be nice I guess
* Generally the code shows that it's a prototype - code quality, test coverage, ...
* Debugger is running on port 5858. So running more than one debug session is currently not
  possible. I'm using the IPC channel between the script- and the bugger-process, didn't find
  yet how to change the debug port without using the node CLI option.
* LiveEdit is pretty certainly not working
* The websocket connection isn't really stable
* Memory usage monitoring is running inside of the script thread. Maybe it would be better to
  externalize this (memory stats should be available to the debug/bugger process).

## Kudos to...

### ...the original projects

bugger is a kind-of-fork of [node-inspector](https://github.com/dannycoates/node-inspector) and
[nodebug](https://github.com/billyzkid/nodebug). Unfortunately both those projects are pretty
outdated and also I was on vacation and had way too much time. There is still some code from both
these projects in bugger.

### WebKit inspector

The frontend is almost 1:1 the webkit inspector, as can be found in the following SVN repository:
```
svn co http://svn.webkit.org/repository/webkit/trunk/Source/WebCore/inspector/front-end/ public/
```

I had to make a few patches to make it work correctly; there was an object created from a
class whose prototype was overwritten later on, some parts of WebKit did not like my hacky
way of handling RemoteObjects, and... I'm sure I forgot something. Maybe I will try to get at
least the first one back into WebKit.
