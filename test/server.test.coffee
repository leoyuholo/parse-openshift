chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
request = require 'supertest'
Parse = require 'parse/node'
config = require 'config'

chai.use chaiAsPromised

describe 'parse-openshift', () ->
	server = require '../lib/server'
	app = ''

	before (done) ->
		Parse.initialize config.get 'appId'
		Parse.serverURL = "#{config.get 'proto'}://localhost:#{config.get 'port'}/parse"
		app = server done

	it 'should response 200 for /', () ->
		request app
			.get '/'
			.expect 200, '<meta http-equiv="refresh" content="0; url=/dashboard" />\n'

	it 'should response 302 for /dashboard/apps', () ->
		request app
			.get '/dashboard/apps'
			.expect 302

	it 'should save test object', () ->
		TestObject = Parse.Object.extend 'TestObject'
		testObject = new TestObject()
		testObject.save foo: 'bar'
