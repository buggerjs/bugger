'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Represents a browser side file or directory.
   * 
   * @param {string} url filesystem: URL for the entry.
   * @param {string} name The name of the file or directory.
   * @param {boolean} isDirectory True if the entry is a directory.
   * @param {string=} mimeType MIME type of the entry, available for a file only.
   * @param {Page.ResourceType=} resourceType ResourceType of the entry, available for a file only.
   * @param {boolean=} isTextFile True if the entry is a text file.
   */
exports.Entry =
function Entry(props) {
  this.url = props.url;
  this.name = props.name;
  this.isDirectory = props.isDirectory;
  this.mimeType = props.mimeType;
  this.resourceType = props.resourceType;
  this.isTextFile = props.isTextFile;
};

  /**
   * Represents metadata of a file or entry.
   * 
   * @param {number} modificationTime Modification time.
   * @param {number} size File size. This field is always zero for directories.
   */
exports.Metadata =
function Metadata(props) {
  this.modificationTime = props.modificationTime;
  this.size = props.size;
};
