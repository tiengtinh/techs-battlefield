((module) ->
  module.directive('gmap', [
    '$window', '$timeout', 'utils', '$rootScope',
    ($window,   $timeout,   utils,   $rootScope) ->   
      {
        scope: gglMapUrl : '@'
        link: (scope, element, attrs) ->
          $timeout ->
            if not document.getElementById 'gmap-script'
              $rootScope.gmapsLoaded = $rootScope.gmapsLoaded || false    
              gm = document.createElement 'script' 
              gm.src = 'http://maps.google.com/maps/api/js?v=3&sensor=false&language=en&callback=gmaps_loaded'
              gm.type = 'text/javascript'
              gm.async = 'true'
              gm.id = 'gmap-script'
              s = document.getElementsByTagName('script')[0]
              s.parentNode.insertBefore(gm, s)

            loadMap = (address) ->              
              gmap = utils.toParams address
              ll = gmap.ll.split ','
              zoom = parseInt gmap.z

              options = {
                map: {
                  # address: address
                  options: {
                    center: ll
                    zoom: zoom
                    styles: [ {
                        stylers: [
                          # { hue: '#00bba6' }
                          # { saturation: -30 }
                        ]
                    } ]
                    scrollwheel: false
                    mapTypeControl: false
                    streetViewControl: false
                  }
                }
                marker: {
                  values:[
                    {latLng: ll, options:{icon: "/images/marker-dark.png"}}
                  ]
                }
              }
              element.gmap3(options)

            window.gmaps_loaded = ->  
              $rootScope.$apply ->
                $rootScope.gmapsLoaded = true                 
            
            $rootScope.$watch 'gmapsLoaded', (newVal, oldVal) ->
              console.log 'gmapsLoaded'
              if newVal then loadMap scope.gglMapUrl

            scope.$watch 'gglMapUrl', (newVal, oldVal) ->
              if($rootScope.gmapsLoaded and newVal)   
                element.gmap3 'destroy'
                loadMap newVal

      }
  ])
) (window.app)
