$ = require 'jquery'
u = require './utilities.coffee'
Cookie = require "js-cookie"

module.exports =


	games:

		choose: (id, callback) ->
			url = "#{u.domen}/api/games/choose.php"
			data = id: id, token: Cookie.get 'token'
			$.post url, data, callback

		list: (success) ->
			url = "#{u.domen}/api/games/list.php"
			data = token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				dataType: 'json'
				data: data
				cache: true
				success: success
				error: -> alert 'api.games.list error'


	quests:

		pass: (questid, answer, callback) ->
			url = "#{u.domen}/api/quests/pass.php"
			data = questid: questid, answer: answer, token: Cookie.get 'token'
			$.post url, data, callback

		list: (success) ->
			url = "#{u.domen}/api/quests/list.php"
			data = token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				dataType: 'json'
				data: data
				cache: true
				success: success
				error: -> alert 'api.quests.list error'
