di = require 'di'

class DbAccess
	constructor: () ->
		console.log 'DbAccess constructor'

	query: ->
		console.log 'query', arguments

class Person
	constructor: (@attrs) ->
		console.log 'Person constructor'

class PersonService
	constructor: (@dbAccess) ->
		console.log 'PersonService constructor'
		#dbAccess is autowired
	
	people: (person) ->
		@dbAccess.query(person)

class HumanResourceController
	constructor: (@personService) ->

	getListPeople: ->
		person = new Person(
				name: 'asdfsadf'
			)
		@personService.people(person)		
		
module = 
	'dbAccess': ['type', DbAccess]
	'personService': ['type', PersonService]
	'humanResourceController': ['type', HumanResourceController]
	'person': ['type', Person]

injector = new di.Injector([module])

injector.invoke (humanResourceController) ->
	humanResourceController.getListPeople()