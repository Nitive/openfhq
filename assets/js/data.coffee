$ = require 'jquery'

u = require './utilities.coffee'

# $.ajax({
# 	type: 'POST',
# 	url: url,
# 	data: data,
# 	success: success,
# 	dataType: dataType,
# 	async:false
# })



# $.post "http://fhq.keva.su/api/security/login.php?email=nitive@icloud.com&password=523105fd&client=openfhq", (response) ->
# 	if token then return token
# 	if response.result = "ok"
# 		token = response.data.token
# 	else
# 		alert "Authorization error"

# $.post "http://fhq.keva.su/api/games/list.php?token=0C73BEA8-B080-4B87-6E82-00F325F122FB", (result) ->
# 	if result.result = "ok"
# 		currentGame = result.current_game

# get data from server here
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
	user:
		name: "Nitive"
		token: null
		currentGame: 0


u.postSync "http://fhq.keva.su/api/security/login.php?email=nitive@icloud.com&password=523105fd&client=openfhq",
	(response) ->
		if response.result is "ok"
			baseData.user.token = response.data.token
			console.log "Token is #{baseData.user.token} now"
		else
			console.warn "Authorization error"

u.postSync "http://fhq.keva.su/api/games/list.php?token=#{baseData.user.token}",
	(response) ->
		if response.result is "ok"
			baseData.user.currentGame = response.current_game
			console.log "Current game is #{baseData.user.currentGame} now"
		else
			console.warn "getting current game error"

module.exports = baseData
