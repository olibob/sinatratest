require 'sinatra'
#require 'sinatra/reloader' if development?
require 'sinatra/flash'
require './song'
require './sinatra/auth'

configure :development do
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
	DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
	set bind: "127.0.0.1"
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