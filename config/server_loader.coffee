_     = require('underscore')
_.str = require('underscore.string')
fs    = require('fs')
path  = require('path')
di  	= require('di')
clc  	= require('cli-color')
routes  	= require('./server_routes')

class AppLoader
	constructor: (app, scanFolder, routes) ->    

		#controller_names = []
		#controllers = []

		module = 
			'app': ['value', app]

		files = @getFileNamesIn path.join(__dirname, '../', scanFolder)
		console.log('')				

		files.forEach (file) ->			
			module[if file.controller or file.service then file.instanceName else file.className] = [
				if file.controller or file.service then 'type' else 'value'
				file.source
			]

			#if file.controller then controller_names.push file.instanceName

		injector = new di.Injector([module])		

		#the controller with routing of '*', which is in this case ServerControlller, must be called last
		#topCtrl = controller_names.shift()
		#controller_names.push(topCtrl)
		
		###eval("""
			injector.invoke(function(#{controller_names.join(', ')}) {
				_.each(arguments, function(each, index){					
					//eval(controller_names[index] + ' = ' + JSON.stringify(each) + ';')
					controllers.push(each);
				});
			})
		""")###	
		
		routes.forEach (route, route_i) ->

			route.run.forEach (middleware, run_i) ->			
				if typeof middleware is 'string'					
					insFun = null
					instance = middleware.split('.')[0]
					method   = middleware.split('.')[1]					
					eval("""
						injector.invoke(function(#{instance}) {
							insFun = #{instance}.#{method}
						})
					""")
					
					routes[route_i].run[run_i] = insFun

			#if not route.public
				#route.run.unshift securify

			args = _.flatten([route.path, route.run])

			console.info clc.bold(route.method.toUpperCase()), '\t', route.path
			
			switch route.method.toUpperCase()
				when 'GET'
					app.get.apply(app, args)
				when 'POST'
					app.post.apply(app, args)
				when 'PUT'
					app.put.apply(app, args)
				when 'DELETE'
					app.delete.apply(app, args)
				else
					throw new Error('Invalid HTTP method specified for route ' + route.path)	
		

	getFileNamesIn: (folder) ->
		result = []

		filos = fs.readdirSync folder #filos = files and folders

		if filos.length > 0
			filos.forEach (filo) =>

				#not a folder
				if @isFile(filo)
					console.info clc.cyan(filo)
					file = 
						fileName 		: filo
						className		: _.str.capitalize(_.str.camelize(filo)).replace(/\.js/, "").replace(/\.coffee/, "")
						instanceName	:	_.str.camelize(filo).replace(/\.js/, "").replace(/\.coffee/, "")
						controller 		: @isController(filo)
						service    		: @isService(filo)
						source		 	: require(path.join(folder, filo))
					
					result.push file

				else #a folder
					@getFileNamesIn(path.join(folder, filo)).forEach (file) ->
						result.push file

		result

	isFile: (name) ->
		_.str.endsWith(name, '.coffee')

	isController: (name) ->
		_.str.endsWith(name, '_controller.coffee')   

	isService: (name) ->
		_.str.endsWith(name, '_service.coffee')


module.exports = AppLoader