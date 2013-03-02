// Generated by CoffeeScript 1.3.3
(function() {
  var AppRouter, FileRequire, app, appRouter, coffeeScript, config, express, fs, http, https, path, server;

  coffeeScript = require('coffee-script');

  config = require('./config').settings;

  express = require('express');

  FileRequire = require('./config/require');

  fs = require('fs');

  http = require('http');

  https = require('https');

  path = require('path');

  AppRouter = require('./app/routers/app_router');

  app = express();

  app.configure(function() {
    app.set("port", config.port || process.env.PORT);
    app.use(express.compress());
    app.use(express.bodyParser({
      uploadDir: path.join(__dirname, '/public/tmp')
    }));
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: 'INSERT YOUR SESSION KEY HERE!!!'
    }));
    app.use(express.logger('dev'));
    app.use('/js', express["static"](path.join(__dirname, '/public/js')));
    app.use('/css', express["static"](path.join(__dirname, '/public/css')));
    app.use('/img', express["static"](path.join(__dirname, '/public/img')));
    app.set('view engine', 'jade');
    return app.set('views', path.join(__dirname, "app/views"));
  });

  FileRequire.load(app, 'controllers');

  server = http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + (app.get('port')));
  });

  appRouter = new AppRouter(app);

}).call(this);