$ = require 'jquery'
Cookie = require "js-cookie"

u = require './utilities.coffee'

baseData =
	rating: [
		{
			name: "keva"
			score: 859195
			country: "Russia"
		}
		{
			name: "More Smoked Leet Chicken"
			score: 769207
			country: "Russia"
		}
		{
			name: "Hackers"
			score: 98234
			country: "India"
		}
		{
			name: "0x234"
			score: 543623
			country: "USA"
		}
		{
			name: "hex"
			score: 235522
			country: "Kazakhstan"
		}
		{
			name: "coolbki"
			score: 234156
			country: "Britain"
		}
		{
			name: "Whatever"
			score: 1235561
			country: "Germany"
		}
	]

u.postSync "http://fhq.keva.su/api/security/login.php?email=nitive@icloud.com&password=523105fd&client=openfhq",
	(response) ->
		if response.result is "ok"
			Cookie.set 'token', response.data.token
		else
			console.warn "Authorization error"

u.postSync "http://fhq.keva.su/api/games/list.php?token=#{Cookie.get 'token'}",
	(response) ->
		if response.result is "ok"
			Cookie.set 'currentGame', response.current_game
		else
			console.warn "getting current game error"

module.exports = baseData
