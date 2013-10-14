###CKEDITOR.plugins.registered['save'] = 
	init: (editor) ->
		command = editor.addCommand('save', {
			modes: {wysiwyg: 1, source: 1}
			readOnly: 1
			exec: (editor) ->
				editor.fire('save')
		})
		console.log 'editor.ui'
		editor.ui.addButton('Save', {
			label : 'Save'
			command : 'save'
		})###

###class CkeditorDirective
	constructor: ($parse) ->
		link = (scope, element, attrs, ngModelCtrl) ->		

			scope.$watch attrs.ngModel, ->
				console.log 'change'

			ngModelCtrl.$parsers.unshift (value) ->
				console.log 'unshift'

			ngModelCtrl.$formatters.unshift (value) ->
				console.log 'formatters'

			ngModelCtrl.$render = ->				
				modelValue = ngModelCtrl.$modelValue		

				element.html modelValue	
				if element.prop("tagName") is 'TEXTAREA'
					ck = CKEDITOR.replace(element[0], {
						uiColor: '#FFFFFF'
					})	
				else
					ck = CKEDITOR.inline(element[0], {
						uiColor: '#FFFFFF'
					})				
				ck.on 'pasteState', ->
					scope.$apply -> ngModelCtrl.$setViewValue(ck.getData())				

				ck.on 'save', ->
					console.log 'save', ck.getData()			

		compile = (tElement, tAttrs) ->
			tElement.append 'some text'

		return {
			link
			#compile
			#locals:
			#	transcluded: '@'
			#replace: true
			require: '^ngModel'
			restrict: 'EA'
			#scope:
				#ngModel: '='
			#	selected: '@'
			#templateUrl: '/views/directives/tab.html'
			#transclude: true
		}###
class CkeditorDirective
	constructor: ($parse) ->
		link = (scope, element, attrs, ngModelCtrl) ->		
				

			if element.prop("tagName") is 'TEXTAREA'
				ck = CKEDITOR.replace(element[0], {
					uiColor: '#FFFFFF'
				})	
			else
				ck = CKEDITOR.inline(element[0], {
					uiColor: '#FFFFFF'
				})	

			ngModelCtrl.$render = ->				
				modelValue = ngModelCtrl.$modelValue		
				ck.setData modelValue

			###ck.on 'instanceReady', ->
				modelValue = ngModelCtrl.$modelValue		
				ck.setData modelValue###

			ck.on 'pasteState', ->
					scope.$apply -> ngModelCtrl.$setViewValue(ck.getData())				

			ck.on 'save', ->
				console.log 'save', ck.getData()
	

		return {
			link
			#compile
			#locals:
			#	transcluded: '@'
			#replace: true
			require: '^ngModel'
			restrict: 'EA'
			#scope:
				#ngModel: '='
			#	selected: '@'
			#templateUrl: '/views/directives/tab.html'
			#transclude: true
		}
angular.module('app').directive 'ckeditor', [ '$parse', CkeditorDirective]