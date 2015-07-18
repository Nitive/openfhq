$ = require 'jquery'
Cookie = require "js-cookie"

module.exports =
	# domen: "http://fhq.sea-kg.com"
	domen: "http://fhq.keva.su"
	setCookie: (name, value) -> Cookie.set name, value, {expires: 365}
