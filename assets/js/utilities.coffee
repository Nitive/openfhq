$ = require 'jquery'
Cookie = require "js-cookie"

module.exports =
	colors:
		linkColor: "#00e090"
	postSync: (url, success) ->
		$.ajax
			type: "POST"
			url: url
			success: success
			dataType: "json"
			async: false

	setCookie: (name, value) -> Cookie.set name, value, {expires: 365}
