# Domain bindings for DOMDebugger
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  DOMDebugger = new EventEmitter()

  # Sets breakpoint on particular operation with DOM.
  #
  # @param nodeId DOM.NodeId Identifier of the node to set breakpoint on.
  # @param type DOMBreakpointType Type of the operation to stop upon.
  DOMDebugger.setDOMBreakpoint = ({nodeId, type}, cb) ->
    # Not implemented

  # Removes DOM breakpoint that was set using <code>setDOMBreakpoint</code>.
  #
  # @param nodeId DOM.NodeId Identifier of the node to remove breakpoint from.
  # @param type DOMBreakpointType Type of the breakpoint to remove.
  DOMDebugger.removeDOMBreakpoint = ({nodeId, type}, cb) ->
    # Not implemented

  # Sets breakpoint on particular DOM event.
  #
  # @param eventName string DOM Event name to stop on (any DOM event will do).
  DOMDebugger.setEventListenerBreakpoint = ({eventName}, cb) ->
    # Not implemented

  # Removes breakpoint on particular DOM event.
  #
  # @param eventName string Event name.
  DOMDebugger.removeEventListenerBreakpoint = ({eventName}, cb) ->
    # Not implemented

  # Sets breakpoint on particular native event.
  #
  # @param eventName string Instrumentation name to stop on.
  DOMDebugger.setInstrumentationBreakpoint = ({eventName}, cb) ->
    # Not implemented

  # Sets breakpoint on particular native event.
  #
  # @param eventName string Instrumentation name to stop on.
  DOMDebugger.removeInstrumentationBreakpoint = ({eventName}, cb) ->
    # Not implemented

  # Sets breakpoint on XMLHttpRequest.
  #
  # @param url string Resource URL substring. All XHRs having this substring in the URL will get stopped upon.
  DOMDebugger.setXHRBreakpoint = ({url}, cb) ->
    # Not implemented

  # Removes breakpoint from XMLHttpRequest.
  #
  # @param url string Resource URL substring.
  DOMDebugger.removeXHRBreakpoint = ({url}, cb) ->
    # Not implemented

  # # Types
  # DOM breakpoint type.
  DOMDebugger.DOMBreakpointType = {"id":"DOMBreakpointType","type":"string","enum":["subtree-modified","attribute-modified","node-removed"],"description":"DOM breakpoint type."}

  return DOMDebugger
