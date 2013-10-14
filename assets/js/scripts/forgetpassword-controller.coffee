class ForgetPasswordController
	constructor : ($scope) ->
		
		$scope.doForgetPass = ->

			utils.dirtify($scope.forgetpassForm);
			if $scope.forgetpassForm.$invalid 
				return

			$scope.loading = true

			UserAccountService.forgetpassword($scope.login).then (rs) ->
				if rs.success
					$scope.success = true
					$scope.error = false
					$scope.message = rs.message
				else 
					$scope.success = false
					$scope.error = true
					$scope.message = rs.message
				$scope.loading = false


angular.module('app').controller 'ForgetPasswordCtrl', ['$scope',  ForgetPasswordController]
