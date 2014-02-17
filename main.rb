require 'sinatra'
require 'sinatra/reloader' if development?
require './song'

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
	enable :sessions
	set :session_secret, '12345678900987654322345326576982757865241'
	set bind: "127.0.0.1"
	set :username, "bob"
	set :password, "superbob"
end

helpers do
	def current?(path='/')
		if path == '/'
			(request.path == path) ? 'class="active"' : ''
		else
			!!(request.path =~ /^#{path}/) ? 'class="active"' : ''
		end
	end

	def set_title
		@title ||= "SBS - Songs By Sinatra"
	end
end

before do
	set_title
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

get '/login' do
	erb :login
end

post '/login' do
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/songs')
	else
		redirect to('/login')
	end
end

get '/logout' do
	session.clear
	redirect to('/login')
end