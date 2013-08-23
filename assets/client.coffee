app = window.app = window.app || {};

angular.module('app', ['ui.state'])
	.config ['$stateProvider', '$locationProvider',
		     ($stateProvider,   $locationProvider) ->  
			     
			     $locationProvider.html5Mode true

			     $stateProvider
			     .state 'index', 
			     	url: '/'
			     	templateUrl: 'partial/index'
			     .state 'contact', 
			     	url: '/contact'
			     	templateUrl: 'partial/contact'
	]