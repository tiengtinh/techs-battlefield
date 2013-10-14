coffeeScript  = require('coffee-script')
config        = require('./config').settings
express       = require('express')
routes     = require('./config/server_routes')
fs            = require('fs')
http          = require('http')
https         = require('https')
connectAssets = require('connect-assets')
path          = require('path')
clc           = require('cli-color')
diap          = require('./../../diap/trunk')
compress 	  = require 'node-jade-compress'

app = express()

app.configure ->
	app.set "port", config.port or process.env.PORT

	app.use express.compress()
	app.use express.bodyParser
		uploadDir: path.join(__dirname,'/public/tmp')
	app.use express.methodOverride()
	app.use express.cookieParser()
	app.use express.session(secret: 'INSERT YOUR SESSION KEY HERE!!!' )	

	app.use connectAssets()
	#app.use connectAssets(helperContext: {js: {root: 'javascript'}, css: {root: ''}})

	app.use '/vendors', express.static(path.join(__dirname,'assets/vendors'))
	app.use '/styles', express.static(path.join(__dirname,'assets/styles'))
	app.use '/images', express.static(path.join(__dirname,'assets/images'))
	app.use '/fonts', express.static(path.join(__dirname,'assets/fonts'))

	app.set 'view engine', 'jade'  
	app.set 'views', path.join(__dirname, "server/views")	

	#compress.init {app: app, js_url: '/js', js_dir: 'assets/'}

app.configure 'development', ->

	t_log = console.log
	console.log = ->
		if arguments.length > 1
			arguments[0] = clc.cyanBright.bold(arguments[0])
		t_log.apply t_log, arguments
		t_log '================================================'
		t_log '' 

	app.use express.logger('dev')
	app.locals.pretty = true

	console.log 'MODE', clc.red('development')

app.configure 'production', -> 	

	console.log 'MODE', clc.red('production')


diap.setup(
	app: app
	scanFolders: [fs.realpathSync('./server/app')]
	#routes: routes
	globalMiddlewares: 
		whenNot:
			public: 'cookieController.checkRememberMe'
)

server = http.createServer(app).listen app.get('port'), ->
	console.log "Express server listening on port #{app.get('port')}"  

###route = []
class FlashController
	constructor: (route) ->
		route.push {
			path: '/api/flash'
			method: 'get'
			run: ['getFlash']
		}

	getFlash: ->
		console.log 'getFlash'

flash = new FlashController(route)
flash.getFlash()
console.log route###