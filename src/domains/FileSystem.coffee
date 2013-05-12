# Domain bindings for FileSystem
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  FileSystem = new EventEmitter()

  # Enables events from backend.
  FileSystem.enable = ({}, cb) ->
    # Not implemented

  # Disables events from backend.
  FileSystem.disable = ({}, cb) ->
    # Not implemented

  # Returns root directory of the FileSystem, if exists.
  #
  # @param origin string Security origin of requesting FileSystem. One of frames in current page needs to have this security origin.
  # @param type temporary|persistent FileSystem type of requesting FileSystem.
  # @returns errorCode integer 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
  # @returns root Entry? Contains root of the requested FileSystem if the command completed successfully.
  FileSystem.requestFileSystemRoot = ({origin, type}, cb) ->
    # Not implemented

  # Returns content of the directory.
  #
  # @param url string URL of the directory that the frontend is requesting to read from.
  # @returns errorCode integer 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
  # @returns entries Entry[]? Contains all entries on directory if the command completed successfully.
  FileSystem.requestDirectoryContent = ({url}, cb) ->
    # Not implemented

  # Returns metadata of the entry.
  #
  # @param url string URL of the entry that the frontend is requesting to get metadata from.
  # @returns errorCode integer 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
  # @returns metadata Metadata? Contains metadata of the entry if the command completed successfully.
  FileSystem.requestMetadata = ({url}, cb) ->
    # Not implemented

  # Returns content of the file. Result should be sliced into [start, end).
  #
  # @param url string URL of the file that the frontend is requesting to read from.
  # @param readAsText boolean True if the content should be read as text, otherwise the result will be returned as base64 encoded text.
  # @param start integer? Specifies the start of range to read.
  # @param end integer? Specifies the end of range to read exclusively.
  # @param charset string? Overrides charset of the content when content is served as text.
  # @returns errorCode integer 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
  # @returns content string? Content of the file.
  # @returns charset string? Charset of the content if it is served as text.
  FileSystem.requestFileContent = ({url, readAsText, start, end, charset}, cb) ->
    # Not implemented

  # Deletes specified entry. If the entry is a directory, the agent deletes children recursively.
  #
  # @param url string URL of the entry to delete.
  # @returns errorCode integer 0, if no error. Otherwise errorCode is set to FileError::ErrorCode value.
  FileSystem.deleteEntry = ({url}, cb) ->
    # Not implemented

  # # Types
  # Represents a browser side file or directory.
  FileSystem.Entry = {"id":"Entry","type":"object","properties":[{"name":"url","type":"string","description":"filesystem: URL for the entry."},{"name":"name","type":"string","description":"The name of the file or directory."},{"name":"isDirectory","type":"boolean","description":"True if the entry is a directory."},{"name":"mimeType","type":"string","optional":true,"description":"MIME type of the entry, available for a file only."},{"name":"resourceType","$ref":"Page.ResourceType","optional":true,"description":"ResourceType of the entry, available for a file only."},{"name":"isTextFile","type":"boolean","optional":true,"description":"True if the entry is a text file."}],"description":"Represents a browser side file or directory."}
  # Represents metadata of a file or entry.
  FileSystem.Metadata = {"id":"Metadata","type":"object","properties":[{"name":"modificationTime","type":"number","description":"Modification time."},{"name":"size","type":"number","description":"File size. This field is always zero for directories."}],"description":"Represents metadata of a file or entry."}

  return FileSystem
