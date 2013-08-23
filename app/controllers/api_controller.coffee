# Api Controller
#
#
class ApiController
  constructor: (app) ->    
    app.get "/api/test", @test       

  test: (req, res) ->
    res.json(
      name: 'Tinh',
      age: 22
    );

module.exports = ApiController

