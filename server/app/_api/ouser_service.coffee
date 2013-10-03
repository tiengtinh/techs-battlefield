Q = require 'q'

class OuserService
  constructor: (@Ouser) ->         

  list: (req, res) ->   
    new @Ouser().query('SELECT * FROM ouser')

module.exports = OuserService

