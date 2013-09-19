coffeeScript  = require('coffee-script')
config        = require('./config').settings
express       = require('express')
AppLoader     = require('./config/app_loader')
logger        = require('./config/logger')
fs            = require('fs')
http          = require('http')
https         = require('https')
connectAssets = require('connect-assets')
path          = require('path')
#AppRouter     = require('./app/routers/app_router')
mysql         = require('mysql')

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
  app.use '/images', express.static(path.join(__dirname,'assets/images'))
  app.use '/fonts', express.static(path.join(__dirname,'assets/fonts'))

  app.set 'view engine', 'jade'  
  app.set 'views', path.join(__dirname, "server/views")
  app.locals.pretty = true;

app.logger = logger

new AppLoader(app, 'server/app')

server = http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"  

#appRouter = new AppRouter(app)