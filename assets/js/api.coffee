$ = require 'jquery'
u = require './utilities.coffee'
Cookie = require "js-cookie"

module.exports =

	security:
		login: (email, password, client, success, data) ->
			url = "#{u.domen}/api/security/login.php"
			console.log "api request: #{url}" # log url
			data = email: email, password: password, client: client
			$.ajax
				type: 'post'
				url: url
				data: data
				success: success
				error: -> alert 'api.security.login error'
				dataType: "json"
				async: if data.async? then data.async else yes


	games:

		choose: (id, success, data) ->
			url = "#{u.domen}/api/games/choose.php"
			console.log "api request: #{url}" # log url
			data = id: id, token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				data: data
				cache: true
				success: success
				error: -> alert 'api.games.choose error'
				async: if data.async? then data.async else yes

		list: (success, data) ->
			url = "#{u.domen}/api/games/list.php"
			console.log "api request: #{url}" # log url
			data = token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				data: data
				cache: true
				success: success
				error: -> alert 'api.games.list error'
				async: if data.async? then data.async else yes


	quests:

		pass: (questid, answer, success, data) ->
			url = "#{u.domen}/api/quests/pass.php"
			console.log "api request: #{url}" # log url
			data = questid: questid, answer: answer, token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				data: data
				cache: true
				success: success
				error: -> alert 'api.quests.pass error'
				async: if data.async? then data.async else yes

		list: (success, data) ->
			url = "#{u.domen}/api/quests/list.php"
			console.log "api request: #{url}" # log url
			data = token: Cookie.get 'token'
			$.ajax
				url: url
				method: 'post'
				data: data
				cache: true
				success: success
				error: -> alert 'api.quests.list error'
				async: if data.async? then data.async else yes
