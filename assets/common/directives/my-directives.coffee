class myDire
	constructor: () ->
		link = (scope, element, attrs, ctrl) ->
			#img = document.createElement('img')
			#img.src = 'http://goo.gl/ceZGf'
			#console.log 'asdf'
			#element.replaceWith(img)

		compile = (tElement, tAttrs) ->
			tElement.append 'some text'

		return {
			link
			compile
			#locals:
			#	transcluded: '@'
			#replace: true
			#require: 'ngModel'
			restrict: 'EA'
			#scope:
			#	caption: '@'
			#	selected: '@'
			#templateUrl: '/views/directives/tab.html'
			#transclude: true
		}

angular.module('app').directive 'myDire', [ myDire]

class Spinner
	constructor: () ->
		#link = (scope, element, attrs, ctrl) ->
			#img = document.createElement('img')
			#img.src = 'http://goo.gl/ceZGf'
			#console.log 'asdf'
			#element.replaceWith(img)

		compile = (tElement, tAttrs, transclude) ->
			console.log 'compile', tAttrs
			
			{
				pre: (scope, iElement, iAttrs, controller) ->
					console.log 'preLink'

				post: (scope, iElement, iAttrs, controller) ->
					console.log 'postLink'
			}

		link = () ->
			console.log 'link'

		return {
			link
			compile
			#locals:
			#	transcluded: '@'
			#replace: true
			#require: 'ngModel'
			restrict: 'EA'
			#scope:
			#	caption: '@'
			#	selected: '@'
			#templateUrl: '/views/directives/tab.html'
			#transclude: true
		}

angular.module('app').directive 'spinner', [ Spinner]