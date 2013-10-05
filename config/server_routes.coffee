path = require 'path'
routes = [	
	{
		path: '/api/user',
		method: 'GET',
		run: [ 
			'apiController.users'
		]
	}
	{
		path: '/api/test',
		method: 'GET',
		run: [ 
			'apiController.test'
		]
	}
	{
		path: '/partial/*',
		method: 'GET',
		run: [ 			
			(req, res) ->
				requestedView = path.join './', req.url
				res.render(requestedView)
		]
		public: true
	}
	{
		path: '*',
		method: 'GET',
		run: [ 
			'serverController.layout'
		]
		public: true
	}
]

module.exports = routes