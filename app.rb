require 'rubygems'
require 'sinatra'
require 'mongo'
require 'json'
require 'bson'

services = JSON.parse(ENV['VMC_SERVICES'])
opt = services[0]['options']
db = Mongo::Connection.new(opt['host'], opt['port']).db(opt['db'])
db.authenticate(opt['username'], opt['password'])
deedCollection = db['deeds']

get '/favicon.ico' do
	send_file 'favicon.ico'
end

get '/' do
	send_file 'views/index.html'
end

get '/whatayidid' do
	result = []
	deedCollection.find.each do |deed|
		result.push(deed)
	end
	JSON.generate(result)
end

post '/agree' do
	deedCollection.update(
		{ '_id' => BSON::ObjectId(params['id']) },
		{ '$inc' => { 'agreements' => 1 } } )
	'success'
end

post '/disagree' do
	deedCollection.update(
		{ '_id' => BSON::ObjectId(params['id']) },
		{ '$inc' => { 'disagreements' => 1 } } )
	'success'
end

post '/tell' do
	deed = {
		'what' => params['what'],
		'who' => params['who'],
		'when' => Time.now,
		'agreements' => 0,
		'disagreements' => 0,
	}
	deedCollection.insert(deed)
	JSON.generate(deed)
end

get '/purge' do
	deedCollection.remove
end

