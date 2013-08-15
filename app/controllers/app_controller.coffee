# App Controller
#
#
class AppController
  constructor: (app) ->
    app.get "/", (req, res) ->      
      res.render('index');

module.exports = AppController

