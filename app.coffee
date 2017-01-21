config = require 'config'

server = require './lib/server'

server () ->
	console.log 'parse-server running on port', config.get 'port'
