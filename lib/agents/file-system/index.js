'use strict';

const BaseAgent = require('../base');

class FileSystemAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables events from backend.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables events from backend.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Returns root directory of the FileSystem, if exists.
   * 
   * @param {string} origin Security origin of requesting FileSystem. One of frames in current page needs to have this security origin.
   * @param {string temporary|persistent} type FileSystem type of requesting FileSystem.
   * 
   * @returns {integer} errorCode 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
   * @returns {Entry=} root Contains root of the requested FileSystem if the command completed successfully.
   */
  requestFileSystemRoot() {
    throw new Error('Not implemented');
  }

  /**
   * Returns content of the directory.
   * 
   * @param {string} url URL of the directory that the frontend is requesting to read from.
   * 
   * @returns {integer} errorCode 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
   * @returns {Array.<Entry>=} entries Contains all entries on directory if the command completed successfully.
   */
  requestDirectoryContent() {
    throw new Error('Not implemented');
  }

  /**
   * Returns metadata of the entry.
   * 
   * @param {string} url URL of the entry that the frontend is requesting to get metadata from.
   * 
   * @returns {integer} errorCode 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
   * @returns {Metadata=} metadata Contains metadata of the entry if the command completed successfully.
   */
  requestMetadata() {
    throw new Error('Not implemented');
  }

  /**
   * Returns content of the file.
   * Result should be sliced into [start, end).
   * 
   * @param {string} url URL of the file that the frontend is requesting to read from.
   * @param {boolean} readAsText True if the content should be read as text, otherwise the result will be returned as base64 encoded text.
   * @param {integer=} start Specifies the start of range to read.
   * @param {integer=} end Specifies the end of range to read exclusively.
   * @param {string=} charset Overrides charset of the content when content is served as text.
   * 
   * @returns {integer} errorCode 0, if no error. Otherwise, errorCode is set to FileError::ErrorCode value.
   * @returns {string=} content Content of the file.
   * @returns {string=} charset Charset of the content if it is served as text.
   */
  requestFileContent() {
    throw new Error('Not implemented');
  }

  /**
   * Deletes specified entry.
   * If the entry is a directory, the agent deletes children recursively.
   * 
   * @param {string} url URL of the entry to delete.
   * 
   * @returns {integer} errorCode 0, if no error. Otherwise errorCode is set to FileError::ErrorCode value.
   */
  deleteEntry() {
    throw new Error('Not implemented');
  }
}

module.exports = FileSystemAgent;
