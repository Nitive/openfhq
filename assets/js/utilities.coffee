$ = require 'jquery'
module.exports =
	postSync: (url, success) ->
		$.ajax
			type: "POST"
			url: url
			success: success
			dataType: "json"
			async: false
