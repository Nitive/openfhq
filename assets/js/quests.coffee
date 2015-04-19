$(->

	########## jQuery variables ##########

	$document = $(document)
	$htmlbody = $('html, body') # html for firefox, body for webkit
	$field = $('.ios-search-field')

	$mainContainer = $('.main-container')
	$menuToggle = $('.menu-toggle')

	$navMenu = $('.nav-menu')
	$navMenuHeader = $navMenu.find('header')

	############# Extra menu #############

	$navMenuHeader.hammer({cssProps: { userSelect: true }}).bind 'tap', ->
		$(this).find(' + ul').slideToggle()

		# toggle class (svg)
		$navMenuHeader.find('svg').attr 'class', (i, attr) ->
			if attr then '' else 'upside'

	########## Open/Close menu ###########

	hideMenu = ->
		$mainContainer.removeClass 'opened-menu'
		setTimeout (-> $navMenu.hide()), 400
	showMenu = ->
		$navMenu.show()
		$mainContainer.addClass 'opened-menu'

	$('.wrap').hammer({cssProps: { userSelect: true }}).bind 'swipe', (event) ->
		if event.gesture.direction == Hammer.DIRECTION_LEFT
			hideMenu()
		if event.gesture.direction == Hammer.DIRECTION_RIGHT
			showMenu()

	$menuToggle.hammer().bind 'tap', (event) ->
		if $mainContainer.hasClass 'opened-menu'
			hideMenu()
		else
			showMenu()

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

