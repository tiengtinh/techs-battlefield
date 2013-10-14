cropper = $('#cropper')
$("#userpic").fileapi
	url: "/api/image"
	accept: "image/*"
	imageSize:
		minWidth: 400
		minHeight: 200

	elements:
		active:
			show: ".js-upload"
			hide: ".js-browse"

		preview:
			el: ".js-preview"
			width: 400
			height: 200

		progress: ".js-progress"

	onSelect: (evt, ui) ->
		file = ui.files[0]
		if file

			cropper.empty()
			cropperCanvas = $('<div></div>')
			cropper.append(cropperCanvas)
			cropperCanvas.cropper
				file: file
				bgColor: "#fff"
				maxSize: [$(window).width() - 400, $(window).height() - 400]
				minSize: [200, 400]
				selection: "90%"
				aspectRatio: 2
				onSelect: (coords) ->
					$("#userpic").fileapi "crop", file, coords

$('#upload').click ->
	$("#userpic").fileapi "upload"
###$("#popup").modal(
closeOnEsc: false
closeOnOverlayClick: false
onOpen: (overlay) ->
	$(overlay).on "click", ".js-upload", ->
		$.modal().close()
		$("#userpic").fileapi "upload"

	$(".js-img", overlay).cropper
		file: file
		bgColor: "#fff"
		maxSize: [$(window).width() - 100, $(window).height() - 100]
		minSize: [200, 200]
		selection: "90%"
		aspectRatio: 1
		onSelect: (coords) ->
			$("#userpic").fileapi "crop", file, coords

).open()###
