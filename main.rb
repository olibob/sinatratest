require 'sinatra'
require 'sinatra/reloader' if development?
require './song'

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