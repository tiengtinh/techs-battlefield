# Api Controller
#
#
class ApiController
  constructor: (app) ->    
    app.get "/api/user/me", @user       

  user: (req, res) ->
    res.json(
      name: 'Tinh',
      age: 22
    );

module.exports = ApiController

