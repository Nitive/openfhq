Snap = require 'snapsvg'

submitQuestIcon = (paper) ->
	bg = paper.rect 0, 0, 50, 32
		.attr
			fill: "none"
			opacity: 0
	g = do paper.g
	g.transform "T13,6"
	path = g.path "M 21,0 L 9,13 3,7 0,10 9,19 24,3 21,0 Z"
		.attr
			fill: "#343d46"

	smClicking = no
	paper.hover (->
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

	paper.mousedown (e) ->
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


questsIcon = (paper) ->
	for i in [0..1]
		for j in [0..1]
			paper.rect 20+i*12, 20+j*12, 8, 8, 1
				.attr
					fill: "none"
					stroke: "#fff"
					strokeWidth: 1.7

gamesIcon = (paper) ->
	paper.circle 30, 30, 15


module.exports =
	navicon: "navicon.svg"
	toggleExtraMenu: "toggle-extra-menu.svg"
	pageHeader:
		quests: questsIcon
		games: gamesIcon

	quest:
		submit: submitQuestIcon
