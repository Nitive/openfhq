if $? then $ ->
	########## jQuery variables ##########

	$document = $(document)
	$htmlbody = $("html, body") # html for firefox, body for webkit
	$window = $(window)

	$field = $(".ios-search-field")

	$mainContainer = $(".main-container")
	$menuToggle = $(".navicon")

	$navMenu = $(".nav-menu")
	$navMenuHeader = $navMenu.find("header")

	$footerArrow = $(".footer-arrow")
	$submitQuest = $(".submit-quest")

	############# Extra menu #############

	$navMenuHeader.hammer().bind "tap", ->
		$(this).find(" + ul").stop().slideToggle("fast")

		# toggle class (svg)
		$navMenuHeader.find("svg").attr "class", (i, attr) ->
			if attr then "" else "upside"

	########## Open/Close menu ###########

	if $window.width() < 600
		$navMenu.hide()

	hideMenu = ->
		$mainContainer.removeClass "opened-nav-menu"
		setTimeout (-> $navMenu.hide()), 400
	showMenu = ->
		$navMenu.show()
		$mainContainer.addClass "opened-nav-menu"

	$(".wrap").hammer({cssProps: { userSelect: true }}).bind "swipe", (event) ->
		if event.gesture.direction == Hammer.DIRECTION_LEFT
			hideMenu()
		if event.gesture.direction == Hammer.DIRECTION_RIGHT
			showMenu()

	$menuToggle.hammer().bind "tap", (event) ->
		if $mainContainer.hasClass "opened-nav-menu"
			hideMenu()
		else
			showMenu()

	$window.resize ->
		$navMenu.show()

	######################################
