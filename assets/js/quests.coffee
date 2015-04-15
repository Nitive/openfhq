$(->

	$mainContainer = $('.main-container')
	$menuToggle = $('.menu-toggle')
	startMargin = 0

	$mainContainer.hammer().bind 'swipe', (event) ->
		if event.gesture.direction == Hammer.DIRECTION_LEFT
			$mainContainer.removeClass 'opened-menu'
		if event.gesture.direction == Hammer.DIRECTION_RIGHT
			$mainContainer.addClass 'opened-menu'

	$menuToggle.hammer().bind 'tap', (event) ->
		$mainContainer.toggleClass 'opened-menu'

) if $?
