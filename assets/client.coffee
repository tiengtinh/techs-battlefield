window.app = angular.module('app', ['ui.state'])
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
			     .state 'social', 
			     	url: '/social'
			     	templateUrl: 'partial/social'
			     .state 'map', 
			     	url: '/map'
			     	templateUrl: 'partial/map'
			     	controller: ($scope, utils) -> 
			     		loc1 = 'https://maps.google.com/maps?q=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&hl=en&ll=10.854349,106.627969&spn=0.008145,0.008959&sll=37.0625,-95.677068&sspn=53.212719,73.388672&oq=quang+trung+software&hq=Quang+Trung+Software+City,+Ho+Chi+Minh+City,+Vietnam&t=m&z=17'
			     		console.log utils.toParams(loc1)
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