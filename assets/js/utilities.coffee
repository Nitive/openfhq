$ = require 'jquery'
Cookie = require "js-cookie"

module.exports =
	domen: "http://fhq.sea-kg.com"
	setCookie: (name, value) -> Cookie.set name, value, {expires: 365}
