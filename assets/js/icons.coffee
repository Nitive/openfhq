Snap = require 'snapsvg'

submitQuestIcon = (svg) ->
	bg = svg.rect 0, 0, 50, 32
		.attr
			fill: "none"
			opacity: 0
	g = do svg.g
	g.transform "T13,6"
	path = g.path "M 21,0 L 9,13 3,7 0,10 9,19 24,3 21,0 Z"
		.attr
			fill: "#343d46"

	smClicking = no
	svg.hover (->
		if smClicking then return
		path.animate
			fill: "#00e090"
			100
			mina.ease
		bg.animate
			fill: "#232831"
			opacity: 1
			100
			mina.ease
	), ->
		if smClicking then return
		path.animate
			fill: "#232831"
			100
			mina.ease
		bg.animate
			fill: "none"
			opacity: 0
			100
			mina.ease

	svg.mousedown (e) ->
		if smClicking then return
		smClicking = yes
		rightFlag = Math.random() > .5
		bg.stop()
		path.stop()
		bgColor =
		if rightFlag then "#00e090" else "#f22e3e"
		path.attr
			fill: "#fff"
		bg.attr
			fill: bgColor
		.animate
			opacity: 1
			500
			mina.lineal
		path.animate
			transform: "s 1.3,1.3"
			1000
			mina.elastic
			->
				@animate
					fill: "#232831"
					transform: "s 1,1",
					100
					mina.lineal
				bg.animate
					opacity: 0
					100
					mina.lineal
					->
						smClicking = no


module.exports =
	quest:
		submit: submitQuestIcon
