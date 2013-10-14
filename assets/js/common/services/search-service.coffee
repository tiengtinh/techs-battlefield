class SearchService
	constructor: () ->	

		highlight = (text) ->
			"<strong>#{text}</strong>"

		SearchService::fuzzyMatch = (searchSet, query) ->
			tokens = query.toLowerCase().split("")
			matches = []
			searchSet.forEach (string) ->
				tokenIndex = 0
				stringIndex = 0
				matchWithHighlights = ""
				matchedPositions = []
				string = string.toLowerCase()
				while stringIndex < string.length
					if string[stringIndex] is tokens[tokenIndex]
						matchWithHighlights += highlight(string[stringIndex])
						matchedPositions.push stringIndex
						tokenIndex++
						if tokenIndex >= tokens.length
							matches.push
								match: string
								highlighted: matchWithHighlights + string.slice(stringIndex + 1)
								positions: matchedPositions

							break
					else
						matchWithHighlights += string[stringIndex]
					stringIndex++

			matches

		
			
angular.module('app').service 'SearchService', [SearchService]