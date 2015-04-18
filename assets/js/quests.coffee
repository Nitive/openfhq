$(->

	########## jQuery variables ##########

	$document = $(document)
	$htmlbody = $('html, body') # html for firefox, body for webkit
	$field = $('.ios-search-field')

	$mainContainer = $('.main-container')
	$menuToggle = $('.menu-toggle')

	$navMenuHeader = $('.nav-menu header')

	############# Extra menu #############

	$navMenuHeader.hammer({cssProps: { userSelect: true }}).bind 'tap', ->
		$(this).find(' + ul').slideToggle()

		# toggle class (svg)
		$navMenuHeader.find('svg').attr 'class', (i, attr) ->
			if attr then '' else 'upside'

	########## Open/Close menu ###########

	$('.wrap').hammer({cssProps: { userSelect: true }}).bind 'swipe', (event) ->
		if event.gesture.direction == Hammer.DIRECTION_LEFT
			$mainContainer.removeClass 'opened-menu'
		if event.gesture.direction == Hammer.DIRECTION_RIGHT
			$mainContainer.addClass 'opened-menu'

	$menuToggle.hammer().bind 'tap', (event) ->
		$mainContainer.toggleClass 'opened-menu'

	########## ios search field ##########

	fieldHeight = $field.height()
	delay = 300
	timer = 0
	rate = .5
	animateTime = 200

	$htmlbody.animate {scrollTop:fieldHeight }, 500, 'swing'
	# $htmlbody.scrollTop(fieldHeight)

	endScroll = ->
		if $document.scrollTop() <= fieldHeight * rate
			$htmlbody.animate { scrollTop: 0 }, animateTime, 'swing'
		else if $document.scrollTop() > fieldHeight * rate and $document.scrollTop() < fieldHeight
			$htmlbody.animate { scrollTop: fieldHeight }, animateTime, 'swing'

	$(window).scroll ->
		clearTimeout timer
		timer = setTimeout endScroll, delay
	######################################

) if $?

