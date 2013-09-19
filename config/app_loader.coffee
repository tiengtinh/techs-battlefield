_     = require('underscore')
_.str = require('underscore.string')
fs    = require('fs')
path  = require('path')

class AppLoader
  constructor: (@app, folder) ->
    @logger = @app.logger      
    @readFoldersRecursively path.join(__dirname, '../', folder), GLOBAL
    AppController = require(path.join(__dirname, '../', folder + '_controller.coffee'))
    new AppController(app)

  isFile: (name) ->
    _.str.endsWith(name, '.coffee')

  isController: (name) ->
    _.str.endsWith(name, '_controller.coffee')    

  readFoldersRecursively: (folder, containerObject) ->    
    _self = @
    logger = @logger
    files = fs.readdirSync folder    
    if files.length > 0
      files.forEach (fileName) ->
        logger.info('fileName: ', fileName)
        if _self.isFile(fileName) #this is a file                    
          if _self.isController(fileName)            
            clazz = require(path.join(folder, fileName))
            new clazz(_self.app)
            logger.info('Controller: ', fileName)
          else 
            # create actual class name
            className = _.str.camelize(fileName)
            className = _.str.capitalize(className)
            className = className.replace(/\.js/, "").replace(/\.coffee/, "")
            
            containerObject[className] = require(path.join(folder, fileName))
            logger.info('GLOBAL: ', className)

        else #this is a folder          
          
          newContainerObject = containerObject[fileName] = {}
          _self.readFoldersRecursively path.join(folder, fileName), newContainerObject    

###load = (@app, folder) ->
  app[folder] = requireFiles path.join("../app/",folder)
    
requireFiles = (folder) ->

  object = {}
  files = fs.readdirSync path.join(__dirname, folder)

  files.forEach (fileName) ->
    
    # skip folder ref and hidden files
    return if _.str.startsWith(fileName, ".")
    
    # remove file extension
    className = fileName.replace(/\.js/, "").replace(/\.coffee/, "")

    # create actual class name
    className = _.str.camelize(className)
    className = _.str.capitalize(className)

    object[className] = require path.join(__dirname, folder, fileName)

    console.log "required: #{className} from #{folder}"

  object###


module.exports = AppLoader