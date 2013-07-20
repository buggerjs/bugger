
# v0.5.0-beta8
* Support for --stfu (surpress any output by bugger itself)
* By default bugger will now exit with the same exit code as the debugged
  process as soon as the debugged process is done. Note that this only affects
  processes that explicitly exit via `process.exit` - otherwise the TCP socket
  to bugger will keep the process alive. The old behavior (keep running after
  the process exited) has to be enabled explicitly via `--hang`.
* Support for detecting hashbangs in files, see `examples/hashbang`
* Clean-up of what is written to stdout/stderr by bugger itself. It will no
  longer polute stdout, so `2>/dev/null` now works.

# v0.5.0-beta7
* Fix for "Add watch"-button
* Fixed JavaScript entry files
* console.profile/console.profileEnd are available, as described in:
  https://developers.google.com/chrome-developer-tools/docs/console-api#consoleprofilelabel
* Network requests now also appear in the Timeline tab
* console.timeStamp, console.time and console.timeEnd are appearing in the Timeline tab
* ANSI color support on stdout
* Inspecting objects that were returned from evaluated expressions in the console tab
  isn't breaking everything

# v0.5.0-beta6
* Support for profiling (heap and cpu)
* Minor bug fixes

# v0.5.0-beta5
* Internal improvements
* Add script files as they are compiled
* Fixed coffee-script debugging, now uses filename.src for the source file
* chrome://devtools -> chrome-devtools://devtools
* Handling Worker.canInspectWorkers
* Network tab is working again

# v0.5.0-beta4
* stdio forwarded to devtools

# v0.5.0-beta3
* Fix bug where unhandled domain functions were crashing the process

# v0.5.0-beta2
* Break on exception

# v0.5.0-beta1
* The most basic things work as expected
* Source maps
* Step-by-step debugging
* Evaluate expressions
