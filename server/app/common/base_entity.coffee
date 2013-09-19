mysql         = require('mysql')
_             = require('underscore')
Q      = require('q')

connectionOptions =
  user: 'root'
  database: 'fitkos-dev'
  password: 'DTHLAdm1n'
  host: '116.193.76.34'
  charset: 'UTF8'
pool = mysql.createPool(connectionOptions)

class BaseEntity

  constructor: (properties)->
    @_properties = properties

  get: (fieldName) ->
    @_properties[fieldName]

  set: (fieldName, value) ->
    @_properties[fieldName] = value    

  paramize: (paramsObj, sql) ->  
    paramsArray = []
    indexedParams = []
    for paramName, paramValue of paramsObj    
      index = sql.indexOf(":#{paramName}")
      if index != -1
        indexedParams.push {name: paramName, index: index, value: paramValue}      
      else
        throw new Error("param named \"#{paramName}\" not found!")
    #reorder params by index
    indexedParams = _.sortBy indexedParams, (each) ->    
      each.index

    for param in indexedParams
      paramsArray.push param.value  
    paramsArray 
  
  query: (sql, params) -> 

    deffer = Q.defer()
    
    params = @paramize(params, sql)

    sql = sql.replace(/:[a-zA-Z]+/g, '?')    

    console.time('pool query')
    pool.getConnection (err, connection) ->

      query = connection.query( sql, params, (err, rows, fields) ->            
        if not err
          console.timeEnd('pool query')
          deffer.resolve(rows)          
        else
          deffer.reject(err)
        connection.release()
      )
      console.log new Date(), query.sql

    deffer.promise
  
  BaseEntity::SELECT_ALL_SQL = "SELECT * FROM ??"
  selectAll: () ->
    deffer = deferred()
    tableName = @_tableName    
    
    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::SELECT_ALL_SQL, [tableName], (err, rows, fields) ->        
        if not err          
          deffer.resolve(rows)          
        else
          deffer.reject(err)
        connection.release()
      )

      console.log query.sql

    deffer.promise

  BaseEntity::INSERT_SQL = "INSERT INTO ?? SET ?"
  insert: ()->

    deffer = deferred()
    tableName = @_tableName
    properties = @_properties
    
    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::INSERT_SQL, [tableName, properties], (err, rows, fields) ->
        
        if not err
          properties.id = rows.insertId          
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)
        connection.release()
      )

      console.log query.sql

    deffer.promise

  BaseEntity::UPDATE_SQL = "UPDATE ?? SET ? WHERE id = ?"
  update: () ->
    deffer = deferred()
    tableName = @_tableName
    properties = @_properties
    id = properties.id
    delete properties.id
    
    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::UPDATE_SQL, [tableName, properties, id], (err, rows, fields) ->
        
        if not err
          properties.id = rows.insertId          
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)

        connection.release()
      )

      console.log query.sql

    deffer.promise   

  save: ->
    if @_properties.id? then @update() else @insert()

  BaseEntity::DELETE_SQL = "DELETE FROM ?? WHERE id = ?"
  delete: ->
    if not properties.id
      throw new Error("id is required")

    deffer = deferred()
    tableName = @_tableName

    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::DELETE_SQL, [tableName, properties.id], (err, rows, fields) ->
        
        if not err
          properties.id = rows.insertId          
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)

        connection.release()
      )

    deffer.promise

module.exports = BaseEntity