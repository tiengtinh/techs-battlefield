coffeeScript  = require('coffee-script')
config        = require('./config').settings
express       = require('express')
FileRequire   = require('./config/require')
fs            = require('fs')
http          = require('http')
https         = require('https')
connectAssets = require('connect-assets')
path          = require('path')
AppRouter     = require('./app/routers/app_router')

app = express()

app.configure ->
  app.set "port", config.port or process.env.PORT

  app.use express.compress()
  app.use express.bodyParser
    uploadDir: path.join(__dirname,'/public/tmp')
  app.use express.methodOverride()
  app.use express.cookieParser()

  app.use express.session(secret: 'INSERT YOUR SESSION KEY HERE!!!' )
  app.use express.logger('dev')

  app.use connectAssets()

  app.use '/styles', express.static(path.join(__dirname,'assets/styles'))

  app.set 'view engine', 'jade'  
  app.set 'views', path.join(__dirname, "app/views")
  app.locals.pretty = true;
  
FileRequire.load app, 'controllers'

server = http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"

appRouter = new AppRouter(app)


