angular.module('app', ['ui.router', 'ngSanitize']).config ['$stateProvider', '$locationProvider', ($stateProvider,   $locationProvider) ->  
						 
	$locationProvider.html5Mode true

	emptyTemplate = "<ui-view></ui-view>"

	$stateProvider		
		.state 'components', 
			url: '/components'
			templateUrl: 'partial/components'
			controller: ['$scope', '$http', ($scope, $http) ->
				$http.get('/api/user/me')
					.then (res) -> 
						$scope.user = res
			]
		.state 'social', 
			url: '/social'
			templateUrl: 'partial/social'
		.state 'contact', 
			url: '/contact'
			templateUrl: 'partial/contact'
		.state 'login', 
			url: '/login'
			templateUrl: 'partial/login'
		.state 'upload', 
			url: '/upload'
			templateUrl: 'partial/upload'
			controller: ['$scope', ($scope) ->
				$scope.addUser = ->
					console.log $scope.user
			]
		.state 'ckeditor', 
			url: '/ckeditor'
			templateUrl: 'partial/ckeditor'
			controller: ['$scope', ($scope) ->
				$scope.save = ->
					console.log $scope.myText
					#console.log $scope.myText2
				
				$scope.myText = """
				<h3>Sharing Resources:</h3>

<p>As mentioned before, open sockets and ports can be shared (for free) by all children in the cluster.  Yay node!</p>

<h3>Worker Managment:</h3>

<p>The cluster module provides a message passing interface between master and slave.  You can pass anything that can be JSON.stringified (no pointers).  We can use these methods to be aware of when a booted worker is ready to accept connections, and conversely, we can tell a worker to begin its graceful shut down process (rather than outright killing the process).  Take a look at the worker code at the bottom of the article for more details.  Note the use of <code>process.send(msg)</code> within the callbacks for <code>actionHero.start()</code> and <code>actionHero.stop()</code>.</p>

<h3>Responding to Signals:</h3>

<p>Unix signals are the classy way to communicate with a running application.  You send them with the <code>kill</code> command, and each signal has a common meaning:</p>
				"""
				$scope.myText2 = """
				<h3>Sharing Resources:</h3>

<p>As mentioned before, open sockets and ports can be shared (for free) by all children in the cluster.  Yay node!</p>

<h3>Worker Managment:</h3>

<p>The cluster module provides a message passing interface between master and slave.  You can pass anything that can be JSON.stringified (no pointers).  We can use these methods to be aware of when a booted worker is ready to accept connections, and conversely, we can tell a worker to begin its graceful shut down process (rather than outright killing the process).  Take a look at the worker code at the bottom of the article for more details.  Note the use of <code>process.send(msg)</code> within the callbacks for <code>actionHero.start()</code> and <code>actionHero.stop()</code>.</p>

<h3>Responding to Signals:</h3>

<p>Unix signals are the classy way to communicate with a running application.  You send them with the <code>kill</code> command, and each signal has a common meaning:</p>
				"""
				$scope.change = ->
					$scope.myText = """
					No favorite story for me, they're all interesting and fun to read, but I like Hans In Luck. Isn't it ironic that for someone who was actually losing (and therefore viewed by the world as a "loser"), thought himself lucky? After losing everything that burdened him, he was finally happy. The key point here is that all the things he acquired, may it be goose or gold, became a heavy load for him which made him suffer. Giving away these objects to others who were obviously just taking advantage of his ignorance makes me think that even today, this happens. People we take for fools, and those who fool fools. 
					"""
			]
		.state 'directive', 
			url: '/directive'
			templateUrl: 'partial/directive'
			controller: ['$scope', ($scope) ->
				$scope.names = ['tinh', 'lam', 'vinh', 'hoang']
				$scope.modifyOne = ->
					$scope.names[0] = 'tiengtinh'
				$scope.modifyAll = ->
					$scope.names = ['hung', 'quang']
			]
		.state 'map', 
			url: '/map'
			templateUrl: 'partial/map'
			controller: ['$scope', 'utils', ($scope, utils) -> 
				loc1 = 'https://maps.google.com/maps?q=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&hl=en&ll=10.854349,106.627969&spn=0.008145,0.008959&sll=37.0625,-95.677068&sspn=53.212719,73.388672&oq=quang+trung+software&hq=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&t=m&z=17'              
				loc2 = 'https://maps.google.com/maps?q=RMIT+International+University+Vietnam,+Nguy%E1%BB%85n+V%C4%83n+Linh,+Ho+Chi+Minh+City,+Vietnam&hl=en&ie=UTF8&ll=10.729619,106.694208&spn=0.007811,0.008959&sll=10.855258,106.628368&sspn=0.002036,0.00224&oq=rmit&hq=RMIT+International+University+Vietnam,+Nguy%E1%BB%85n+V%C4%83n+Linh,+Ho+Chi+Minh+City,+Vietnam&t=m&z=17'
				#https://maps.google.com/maps?q=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&hl=en&ll=10.855258,106.628368&spn=0.002036,0.00224&sll=37.0625,-95.677068&sspn=53.212719,73.388672&oq=quang+trung+software&hq=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&t=m&z=19
				address1 = 'Quang Trung Software City, Ho Chi Minh City, Vietnam'
				address2 = 'Tan Son Nhat International Airport, phường 4, Ho Chi Minh City, Vietnam'
				flag = false            
				$scope.address = loc1
				$scope.address2 = loc2
				$scope.toggleAddress = ->
					 $scope.address = if flag then loc1 else loc2
					 $scope.address2 = if not flag then loc1 else loc2
					 flag = not flag
			]
		.state 'master', 
			url: '/'
			template: emptyTemplate
			#controller: 'AuthCtrl'
		.state 'master.auth', 
			url: 'auth'
			templateUrl: '/partial/auth'
			#controller: 'AuthCtrl'
		.state 'master.auth.signin', 
			url: '/signin?back'
			templateUrl: '/partial/auth-signin'
			controller: 'SigninController'
			title: 'btn.login'
		.state 'master.auth.forgetPassword', 
			url: '/forgetpassword'
			templateUrl: '/partial/auth-forgetpassword'
			controller: 'ForgetPasswordCtrl'

		.state 'search', 
			url: '/search'
			templateUrl: '/partial/search'
			controller: ['$scope', 'SearchService', ($scope, SearchService) ->
				$scope.searchSet = searchSet = [
					'Image Microsystems of Austin'
					'reverse logistics'
					'is a good replacement for metals used in'
					'Best Global Green Brands'
					'Corproate Knights Global 100'
					'Trust Across America'
					'Amtrak allows pets in carriers'
					'common practice for PR agencies to vet media pitches'
					'really up to the agency or PR provider whether or not to share a media pitch'
					'but if youre looking to edit the roster of '
					'Considering multiple sources'
				]

				$scope.search = ->
					$scope.rows = SearchService.fuzzyMatch(searchSet, $scope.query)		
			]			
						
	]