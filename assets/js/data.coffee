$ = require 'jquery'
Cookie = require "js-cookie"

u = require './utilities.coffee'
api = require './api.coffee'

baseData =
	errors:
		1216: 'Answer incorrect'
		1217: 'Quest already passed'
		1318: 'Your already try this answer'
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

unless Cookie.get 'token'
	api.security.login 'nitive@icloud.com', 'fb827d8d', 'openfhq', ((response) ->
		if response.result is 'ok'
			Cookie.set 'token', response.data.token
		else
			console.warn 'Authorization error'
	), async: no

unless Cookie.get 'currentGame'
	api.games.list ((response) ->
		if response.result is 'ok'
			Cookie.set 'currentGame', response.current_game
	), async: no

module.exports = baseData
