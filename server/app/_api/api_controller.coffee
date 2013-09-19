Ouser = GLOBAL.acommon.entities.Ouser
fs = require('fs')

class ApiController
  constructor: (@app) ->        
    app.get "/api/user", @users    

  users: (req, res) ->   
    console.time('users')            
    new Ouser().query('SELECT * FROM ouser').done (users) ->
      res.json(users)      
      console.timeEnd('users')         

module.exports = ApiController

