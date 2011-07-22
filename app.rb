require 'rubygems'
require 'sinatra'
#require 'mongo'
require 'json'

#db = Mongo::Connection.new.db('ihateayi')
#deedCollection = db['deeds']


get '/' do
	send_file 'views/index.html'
end

get '/whatayidid' do
	result = []
	deedCollection.find().each do |deed|
		result.push({
			'content' => deed.content
		})
	end
	JSON.stringify(result)
end

post '/tell' do
	deed = {
		'content' => params[:content]
	}
	deedCollection.insert(deed)
end
