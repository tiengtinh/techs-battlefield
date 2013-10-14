
class SigninController
	constructor : ($scope, $state, $stateParams) ->
		$scope.login = 
			remember : true

		$scope.doLogin = ->			
			utils.dirtify($scope.loginForm);
			if $scope.loginForm.$invalid 
				return
			$scope.loading = true
			UserAccountService.signin($scope.login).then (rs) ->
				if rs.success					
					$scope.error = false
					console.log $cookies.back
					if $cookies.back and $cookies.back != '/' and not /^\/resources\//i.test($cookies.back)
						if $cookies.backState == 'true'
							$state.go $cookies.back, JSON.parse($cookies.backQuery)
						else 
							$location.search(JSON.parse($cookies.backQuery)).path $cookies.back
					else if $stateParams.back and $stateParams.back != '/'
						$location.path $stateParams.back
					else
						$state.go 'master.app.course.list'
				else 
					$scope.errorMessage = rs.message
					$scope.error = true	
				$scope.loading = false		


angular.module('app').controller 'SigninController', ['$scope', '$state', '$stateParams', SigninController]
