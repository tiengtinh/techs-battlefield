class AppController
  constructor: (@app) ->    
    app.get "/", @layout
    app.get "/partial/:name", @partial    
    app.get "*", @layout

  layout: (req, res) ->
    res.render('layout')

  partial: (req, res) ->
    res.render('partials/' + req.params.name)      

module.exports = AppController
