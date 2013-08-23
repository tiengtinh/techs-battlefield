# App Router
#
#
class AppRouter
  constructor: (@app) ->
    @setupRoutes()

  setupRoutes: ->
    new @app.controllers.ApiController @app
    new @app.controllers.AppController @app    

module.exports = AppRouter

