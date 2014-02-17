require 'sinatra'
require 'sinatra/reloader' if development?
require './song'

configure do
	enable :sessions
	set :session_secret, '12345678900987654322345326576982757865241'
	set bind: "127.0.0.1"
	set :username, "bob"
	set :password, "superbob"
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
	session[:name] = params[:name]
end

get '/get/hello' do
	"Hello, #{session[:name]}"
end