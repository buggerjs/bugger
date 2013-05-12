# Domain bindings for IndexedDB
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  IndexedDB = new EventEmitter()

  # Enables events from backend.
  IndexedDB.enable = ({}, cb) ->
    # Not implemented

  # Disables events from backend.
  IndexedDB.disable = ({}, cb) ->
    # Not implemented

  # Requests database names for given security origin.
  #
  # @param securityOrigin string Security origin.
  # @returns databaseNames string[] Database names for origin.
  IndexedDB.requestDatabaseNames = ({securityOrigin}, cb) ->
    # Not implemented

  # Requests database with given name in given frame.
  #
  # @param securityOrigin string Security origin.
  # @param databaseName string Database name.
  # @returns databaseWithObjectStores DatabaseWithObjectStores Database with an array of object stores.
  IndexedDB.requestDatabase = ({securityOrigin, databaseName}, cb) ->
    # Not implemented

  # Requests data from object store or index.
  #
  # @param securityOrigin string Security origin.
  # @param databaseName string Database name.
  # @param objectStoreName string Object store name.
  # @param indexName string Index name, empty string for object store data requests.
  # @param skipCount integer Number of records to skip.
  # @param pageSize integer Number of records to fetch.
  # @param keyRange KeyRange? Key range.
  # @returns objectStoreDataEntries DataEntry[] Array of object store data entries.
  # @returns hasMore boolean If true, there are more entries to fetch in the given range.
  IndexedDB.requestData = ({securityOrigin, databaseName, objectStoreName, indexName, skipCount, pageSize, keyRange}, cb) ->
    # Not implemented

  # Clears all entries from an object store.
  #
  # @param securityOrigin string Security origin.
  # @param databaseName string Database name.
  # @param objectStoreName string Object store name.
  IndexedDB.clearObjectStore = ({securityOrigin, databaseName, objectStoreName}, cb) ->
    # Not implemented

  # # Types
  # Database with an array of object stores.
  IndexedDB.DatabaseWithObjectStores = {"id":"DatabaseWithObjectStores","type":"object","description":"Database with an array of object stores.","properties":[{"name":"name","type":"string","description":"Database name."},{"name":"version","type":"string","description":"Deprecated string database version."},{"name":"intVersion","type":"integer","description":"Integer database version."},{"name":"objectStores","type":"array","items":{"$ref":"ObjectStore"},"description":"Object stores in this database."}]}
  # Object store.
  IndexedDB.ObjectStore = {"id":"ObjectStore","type":"object","description":"Object store.","properties":[{"name":"name","type":"string","description":"Object store name."},{"name":"keyPath","$ref":"KeyPath","description":"Object store key path."},{"name":"autoIncrement","type":"boolean","description":"If true, object store has auto increment flag set."},{"name":"indexes","type":"array","items":{"$ref":"ObjectStoreIndex"},"description":"Indexes in this object store."}]}
  # Object store index.
  IndexedDB.ObjectStoreIndex = {"id":"ObjectStoreIndex","type":"object","description":"Object store index.","properties":[{"name":"name","type":"string","description":"Index name."},{"name":"keyPath","$ref":"KeyPath","description":"Index key path."},{"name":"unique","type":"boolean","description":"If true, index is unique."},{"name":"multiEntry","type":"boolean","description":"If true, index allows multiple entries for a key."}]}
  # Key.
  IndexedDB.Key = {"id":"Key","type":"object","description":"Key.","properties":[{"name":"type","type":"string","enum":["number","string","date","array"],"description":"Key type."},{"name":"number","type":"number","optional":true,"description":"Number value."},{"name":"string","type":"string","optional":true,"description":"String value."},{"name":"date","type":"number","optional":true,"description":"Date value."},{"name":"array","type":"array","optional":true,"items":{"$ref":"Key"},"description":"Array value."}]}
  # Key range.
  IndexedDB.KeyRange = {"id":"KeyRange","type":"object","description":"Key range.","properties":[{"name":"lower","$ref":"Key","optional":true,"description":"Lower bound."},{"name":"upper","$ref":"Key","optional":true,"description":"Upper bound."},{"name":"lowerOpen","type":"boolean","description":"If true lower bound is open."},{"name":"upperOpen","type":"boolean","description":"If true upper bound is open."}]}
  # Data entry.
  IndexedDB.DataEntry = {"id":"DataEntry","type":"object","description":"Data entry.","properties":[{"name":"key","$ref":"Runtime.RemoteObject","description":"Key."},{"name":"primaryKey","$ref":"Runtime.RemoteObject","description":"Primary key."},{"name":"value","$ref":"Runtime.RemoteObject","description":"Value."}]}
  # Key path.
  IndexedDB.KeyPath = {"id":"KeyPath","type":"object","description":"Key path.","properties":[{"name":"type","type":"string","enum":["null","string","array"],"description":"Key path type."},{"name":"string","type":"string","optional":true,"description":"String value."},{"name":"array","type":"array","optional":true,"items":{"type":"string"},"description":"Array value."}]}

  return IndexedDB
