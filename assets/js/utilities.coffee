$ = require 'jquery'
Cookie = require "js-cookie"

module.exports =
	domen: "http://fhq.sea-kg.com"
	postSync: (url, data, success) ->
		$.ajax
			type: "POST"
			url: url
			data: data
			success: success
			dataType: "json"
			async: false

	setCookie: (name, value) -> Cookie.set name, value, {expires: 365}
