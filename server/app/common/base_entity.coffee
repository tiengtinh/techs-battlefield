mysql         = require('mysql')
_             = require('underscore')
Q      = require('q')

connectionOptions =
  user: 'root'
  database: 'test'
  password: 'root'
  host: 'localhost'
  charset: 'UTF8'
pool = mysql.createPool(connectionOptions)


#settting for connection param strings
pool.getConnection (err, connection) ->
  connection.config.queryFormat = (query, values) ->    
    return query  unless values

    #replace object params of conditions in WHERE clause
    query = query.replace /:::[a-zA-Z0-9]+/g, (txt, key) ->      
      paramName = txt.replace(/:/g, '')
      if values.hasOwnProperty(paramName)
        paramValue = values[paramName]        
        if typeof paramValue is 'object'
          oParams = []
          for key, value of paramValue
            if typeof value is 'string' 
              oParams.push "#{mysql.escapeId(key)} LIKE #{mysql.escape(value)}".replace /%25/g, '%'
            else
              oParams.push "#{mysql.escapeId(key)} = #{mysql.escape(value)}"
          return oParams.join ' AND '
      txt          
    
    #replace params typed ::idetifier
    query = query.replace /::[a-zA-Z0-9]+/g, (txt, key) ->      
      paramName = txt.replace(/:/g, '')
      if values.hasOwnProperty(paramName)
        paramValue = values[paramName]        
        return mysql.escapeId(paramValue) if typeof paramValue is 'string'

        if Array.isArray(paramValue)
          oParams = []
          for param in paramValue
            oParams.push mysql.escapeId(param)
          return oParams.join ', '
        ###if typeof paramValue is 'object'
          oParams = []
          for key, value of paramValue
            concatenator = if typeof value is 'string' then 'LIKE' else '='
            oParams.push "#{mysql.escapeId(key)} #{concatenator} #{@escape(value)}"###

        return mysql.escape(paramValue)
      txt
    
    #replace params typed :param
    query = query.replace /:[a-zA-Z0-9]+/g, (txt, key) ->      
      paramName = txt.replace(/:/g, '')
      paramValue = values[paramName]
      if values.hasOwnProperty(paramName)
        return "'#{@escape(paramValue)}'".replace /%25/g, '%' if typeof paramValue is 'string'
        return mysql.escape(paramValue)
      txt

    
    query 

### basic case
sql = """
    SELECT id, `code` FROM ::tableName WHERE hide = :SHOW AND inactive = :ACTIVE ORDER BY sort
    """
params = 
      SHOW : 0
      ACTIVE: 0
      tableName: 'cat_course'###
### advanced case
sql = """
    SELECT ::fields FROM ::tableName WHERE :::conditions ORDER BY sort
    """
params =      
      tableName: 'cat_course'
      fields: ['id', 'code']      
      conditions: 
        hide : 0
        inactive: 0###
        

class BaseEntity

  constructor: (properties)->
    @_properties = properties

  get: (fieldName) ->
    @_properties[fieldName]

  set: (fieldName, value) ->
    @_properties[fieldName] = value    

  ###paramize: (paramsObj, sql) ->  
    paramsArray = []
    indexedParams = []

    regex = /(::[a-zA-Z]+)|(:[a-zA-Z]+)/g

    paramNames = sql.match(regex)

    for paramName in paramNames      
      paramName = paramName.replace(/:/g, '')
      paramValue = paramsObj[paramName]

      if not paramValue?
        throw new Error("param named \"#{paramName}\" not set!")

      indexedParams.push {name: paramName, index: _i, value: paramValue}
    console.log 'indexedParams', indexedParams    

    #reorder params by index
    indexedParams = _.sortBy indexedParams, (each) ->    
      each.index

    #for param in indexedParams
      paramsArray.push param.value  
    paramsArray ###

  executeSql: (sql, params, callback) ->
    pool.getConnection (err, connection) ->

      query = connection.query( sql, params, (err, rows, fields) ->            
        callback(err, rows, fields)

        try
          #TODO: mysql native client access
          connection.release()
        catch error
          console.log 'connection error', error

      )
      console.info query.sql

  
  query: (sql, params) -> 

    deffer = Q.defer()
        
    console.time('pool query')

    @executeSql sql, params, (err, rows, fields) ->    
      if not err          
        deffer.resolve(rows)          
        console.timeEnd('pool query')
      else
        deffer.reject(err)      

    deffer.promise

  
  BaseEntity::SELECT_ALL_SQL = "SELECT * FROM ::tableName"
  selectAll: () ->
    params =
      tableName: @_tableName

    @query BaseEntity::SELECT_ALL_SQL, params   


  BaseEntity::INSERT_SQL = "INSERT INTO ::tableName SET ::fieldsValues"
  insert: ()->
    properties = @_properties
    params =
      tableName: @_tableName
      fieldsValues: @_properties

    deffer = Q.defer()    
    
    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::INSERT_SQL, params, (err, rows, fields) ->
        if not err
          properties.id = rows.insertId          
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)
        connection.release()
      )

      console.log query.sql

    deffer.promise


  BaseEntity::UPDATE_SQL = "UPDATE ::tableName SET ::fieldsValues WHERE id = :id"
  update: () ->

    properties = @_properties

    if not properties.id
      throw new Error("id is required")

    params =
      tableName: @_tableName
      fieldsValues: @_properties
      id: properties.id

    deffer = Q.defer()
        
    delete properties.id
    
    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::UPDATE_SQL, params, (err, rows, fields) ->
        
        if not err
          properties.id = params.id       
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)

        connection.release()
      )

      console.log query.sql

    deffer.promise   


  save: ->
    if @_properties.id? then @update() else @insert()

  BaseEntity::DELETE_SQL = "DELETE FROM ::tableName WHERE id = :id"
  delete: ->

    if not properties.id
      throw new Error("id is required")

    params =
      tableName: @_tableName      
      id: properties.id

    deffer = Q.defer()
    tableName = @_tableName

    pool.getConnection (err, connection) ->      
      query = connection.query( BaseEntity::DELETE_SQL, params, (err, rows, fields) ->
        
        if not err                
          deffer.resolve(rows.serverStatus)          
        else
          deffer.reject(err)

        connection.release()
      )

      console.log query.sql

    deffer.promise

  queryBuilder: ->

    entity = @

    class QueryBuilder
      constructor: ->

      ###*
       * set fields to select from
       * @param  {Array} fields [description]
       * @return {QueryBuilder}        [description]
      ###
      select: (@fields)->        
        @

      ###*
       * set where condition
       * @param  {object} @conditions [description]
       * @return {QueryBuilder}         [description]
      ###
      where: (@conditions) ->
        @

      QueryBuilder::SQL_SELECT = 'SELECT ::fields FROM ::tableName'
      QueryBuilder::SQL_SELECT_WHERE = 'SELECT ::fields FROM ::tableName WHERE :::conditions'
      execute: () ->
        executeParams = {}

        sql_frame = if @conditions? then QueryBuilder::SQL_SELECT_WHERE else QueryBuilder::SQL_SELECT        

        executeParams.fields = @fields
        executeParams.tableName = entity._tableName
        if @conditions? then executeParams.conditions = @conditions        

        entity.query(sql_frame, executeParams)


    new QueryBuilder()

module.exports = BaseEntity