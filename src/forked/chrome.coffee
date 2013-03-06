
path = require 'path'
fs = require 'fs'
{execFile} = require 'child_process'

firstExistingPath = (paths) ->
  for path in paths
    return path if fs.existsSync path
  null

findChrome = ->
  paths = switch process.platform
    when 'win32'
      [ path.join(process.env['LocalAppData'], 'Google', 'Chrome', 'Application', 'chrome.exe')
      , path.join(process.env["ProgramFiles"], "Google", "Chrome", "Application", "chrome.exe")
      , path.join(process.env["ProgramFiles(x86)"], "Google", "Chrome", "Application", "chrome.exe") ]
    when 'darwin'
      [ path.join("/", "Applications", "Google Chrome.app", "Contents", "MacOS", "Google Chrome") ]
    else
      [ path.join("/", "opt", "google", "chrome", "google-chrome") ]

  firstExistingPath paths

module.exports = (host, port, debugPort) ->
  chromeProfilePath = path.join __dirname, '..', 'ChromeProfile'
  args = [
    "--app=http://#{host}:#{port}/debug?port=#{debugPort}",
    "--user-data-dir=#{chromeProfilePath}" ]

  chromePath = findChrome()

  unless chromePath
    throw new Error("Chrome not found")

  execFile(chromePath, args)
