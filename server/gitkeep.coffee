module.exports = ->

	new class ServerController

		routes: [			
				path: '/gomap',
				method: 'GET',
				run: [ 
					'gomap'
				]
				public: true
			,
				path: '/fileapi',
				method: 'GET',
				run: [ 
					'fileapi'
				]
				public: true
			,
				path: '/partial/:name',
				method: 'GET',
				run: [
					'partial'
				]
				public: true
			,			
				path: '*',
				method: 'GET',
				run: [ 
					'layout'
				]
				public: true						
		]

		constructor: () ->   									

		layout: (req, res) ->		
			res.render('layout')

		partial: (req, res) ->
			res.render('partials/' + req.params.name)  

		gomap: (req, res) ->
			res.render('gomap')

		fileapi: (req, res) ->
			res.render('fileapi')


	
