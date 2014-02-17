require 'sinatra'
require 'sinatra/reloader' if development?
require './song'

configure do
	enable :sessions
end

get '/' do
	erb :home
end

get '/about' do
	@title = "SBS - All about this site"
	erb :about
end

get '/contact' do
	@title = "SBS - Contact information"
	erb :contact
end

not_found do
	erb :not_found
end

get '/set/:name' do
	sessions[:name] = params[:name]
end

get '/get/hello/' do
	"Hello, #{sessions[:name]}"
end