# Domain bindings for Database
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Database = new EventEmitter()

  # Enables database tracking, database events will now be delivered to the client.
  Database.enable = ({}, cb) ->
    # Not implemented

  # Disables database tracking, prevents database events from being sent to the client.
  Database.disable = ({}, cb) ->
    # Not implemented

  # @param databaseId DatabaseId 
  # @returns tableNames string[] 
  Database.getDatabaseTableNames = ({databaseId}, cb) ->
    # Not implemented

  # @param databaseId DatabaseId 
  # @param query string 
  # @returns columnNames string[]? 
  # @returns values any[]? 
  # @returns sqlError Error? 
  Database.executeSQL = ({databaseId, query}, cb) ->
    # Not implemented

  # @param databaseId DatabaseId 
  # @param query string 
  Database.emit_executeSQL = (params) ->
    notification = {params, method: 'Database.executeSQL'}
    @emit 'notification', notification

  # # Types
  # Unique identifier of Database object.
  Database.DatabaseId = {"id":"DatabaseId","type":"string","description":"Unique identifier of Database object.","hidden":true}
  # Database object.
  Database.Database = {"id":"Database","type":"object","description":"Database object.","hidden":true,"properties":[{"name":"id","$ref":"DatabaseId","description":"Database ID."},{"name":"domain","type":"string","description":"Database domain."},{"name":"name","type":"string","description":"Database name."},{"name":"version","type":"string","description":"Database version."}]}
  # Database error.
  Database.Error = {"id":"Error","type":"object","description":"Database error.","properties":[{"name":"message","type":"string","description":"Error message."},{"name":"code","type":"integer","description":"Error code."}]}

  return Database
