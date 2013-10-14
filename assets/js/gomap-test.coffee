$ ->
	getBoundsZoomLevel = (bounds, mapDim) ->
		latRad = (lat) ->
			sin = Math.sin(lat * Math.PI / 180)
			radX2 = Math.log((1 + sin) / (1 - sin)) / 2
			Math.max(Math.min(radX2, Math.PI), -Math.PI) / 2
		zoom = (mapPx, worldPx, fraction) ->
			Math.floor Math.log(mapPx / worldPx / fraction) / Math.LN2
		WORLD_DIM =
			height: 256
			width: 256

		ZOOM_MAX = 21
		ne = bounds.getNorthEast()
		sw = bounds.getSouthWest()
		latFraction = (latRad(ne.lat()) - latRad(sw.lat())) / Math.PI
		lngDiff = ne.lng() - sw.lng()
		lngFraction = ((if (lngDiff < 0) then (lngDiff + 360) else lngDiff)) / 360
		latZoom = zoom(mapDim.height, WORLD_DIM.height, latFraction)
		lngZoom = zoom(mapDim.width, WORLD_DIM.width, lngFraction)
		Math.min latZoom, lngZoom, ZOOM_MAX

	map = $('#map').goMap
		address: 'Quang Trung Software City, Ho Chi Minh City, Vietnam'
		maptype: 'ROADMAP'		
		zoom: 16
		addMarker: true
		markers: [
			{id: 'default', latitude: '10.85358', longitude: '106.629632', draggable: true} 
		]
	mapDim = { height: map.height(), width: map.width() }

	setMarker = (latLng) ->
		$.goMap.clearMarkers()
		options = {
			position:  latLng,
			draggable: true
		}
		marker = $.goMap.createMarker(options)

	$.goMap.createListener {type:'map'}, 'click', (event) ->		
		map.goMap()
		setMarker event.latLng				

	address = $('#address').geocomplete()
	address.bind "geocode:result", (event, result) ->
			map.goMap()
			geometry = result.geometry 
			
			address.val result.formatted_address
			
			gmap = $.goMap.getMap()
			if geometry.viewport
				console.log 'map by viewport'
				gmap.fitBounds(geometry.viewport)
				setMarker geometry.viewport.getCenter()				
			else if geometry.location
				console.log 'map by location'
				gmap.setCenter(geometry.location)
				gmap.setZoom(17)
			else
				console.log 'map by text'
				$.goMap.setMap
					address: address.val()
					zoom: 17

	address.bind "geocode:error", (event, status) ->
		console.log 'geocode:error', status
	address.bind "geocode:multiple", (event, results) ->
		console.log 'geocode:multiple', results


	#MAP 2
	map2 = $('#map2').goMap
		address: 'Bitexco Building, Nguyễn Huệ, Bến Nghé, Ho Chi Minh City, Vietnam'
		maptype: 'ROADMAP'		
		#zoom: 16
	
	#END MAP2
	tempBound = null
	tempZoom = null
	tempCenter = null
	tempMarker = null
	lat = 0
	lng = 0
	$('#search1').click ->
		address.trigger("geocode")

	$('#search2').click ->
		map2.goMap()
		gmap2 = $.goMap.getMap()
		#gmap2.fitBounds JSON.parse(tempBound)		
		center = new google.maps.LatLng(lat, lng)
		console.log 'center', center
		gmap2.setCenter(center)
		gmap2.setZoom(tempZoom)

	$('#marker1').click ->
		map.goMap()
		marker = $.goMap.getMarkers("json")
		console.log marker

	$('#location').click ->
		map.goMap()
		gmap = $.goMap.getMap()
		tempBound = JSON.stringify($.goMap.getBounds())
		tempZoom = gmap.getZoom()
		tempCenter = $.goMap.getBounds().getCenter()
		console.log 'bounds', tempBound
		console.log 'center', $.goMap.getBounds().getCenter()
		console.log 'zoom', getBoundsZoomLevel($.goMap.getBounds(), mapDim), gmap.getZoom()
		lat = tempCenter.lat()
		lng = tempCenter.lng()

		#marker = $.goMap.getMarkers("json").markers['0']
		#if marker
			#tempMarker = null #TODO