express = require 'express'
config = require 'config'
ParseServer = (require 'parse-server').ParseServer
ParseDashboard = require 'parse-dashboard'

started = false

init = (done) ->
	return done() if started
	started = true

	allowInsecureHTTP = (config.get 'proto') == 'http'

	api = new ParseServer
		databaseURI: config.get 'databaseURI'
		appId: config.get 'appId'
		masterKey: config.get 'masterKey'
		serverURL: "#{config.get 'proto'}://localhost:#{config.get 'port'}/parse"

	dashboard = new ParseDashboard({
		apps: [{
			serverURL: "#{config.get 'proto'}://#{config.get 'host'}:#{config.get 'port'}/parse"
			appId: config.get 'appId'
			masterKey: config.get 'masterKey'
			appName: config.get 'appName'
		}]
		users: [{
			user: config.get 'user'
			pass: config.get 'pass'
		}]
	}, allowInsecureHTTP);

	app = express()
	app.use '/parse', api
	app.use '/dashboard', dashboard
	app.use express.static 'static'

	app.listen (config.get 'port'), done

module.exports = init
