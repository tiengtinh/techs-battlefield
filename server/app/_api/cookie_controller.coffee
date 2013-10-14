module.exports =  (ouserService) ->
	new class CookieController

		routes: [
			path: '/api/user',
			method: 'GET',
			run: [ 
				'checkRememberMe'
			]			

		]

		constructor: () ->
			#app.get "/api/user", @users

		checkRememberMe: (req, res, next) =>
			#ouserService.list().then (ousers) ->
				#console.log 'cookie'
			next()
	
	#module.exports = ApiController