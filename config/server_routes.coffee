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
		path: '/partial/:name',
		method: 'GET',
		run: [ 
			(req, res, next) ->
				console.log 'before partial'
				next()
			(req, res) ->
				res.render('partials/' + req.params.name)
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