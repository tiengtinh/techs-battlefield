angular.module('app').service('utils', [
  '$timeout',
  ($timeout) ->
    @toParams = (url) ->
      objectParams = {}
      if url.indexOf('?') != -1
        stringParams = url.substring(location.href.indexOf('?') + 1)
        arrayParams = stringParams.split('&')
        for each in arrayParams
          eachPair = each.split('=')
          objectParams[eachPair[0]] = eachPair[1]
      objectParams
    @
])