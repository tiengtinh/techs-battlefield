class ApiController
	constructor: (@ouserService) ->  			
		#app.get "/api/user", @users

	users: (req, res) =>   
		@ouserService.list().then (users) ->
			res.json users

	test: (req, res) =>   		
		res.json 'test'

module.exports = ApiController

