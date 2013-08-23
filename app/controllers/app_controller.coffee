# App Controller
#
#
class AppController
  constructor: (app) ->
    app.get "/", (req, res) ->      
      res.render('layout');
    app.get "/partial/:name", (req, res) ->      
      res.render('partials/' + req.params.name);  
    app.get "*", (req, res) ->      
      res.render('layout');

module.exports = AppController

