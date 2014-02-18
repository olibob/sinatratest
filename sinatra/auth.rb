require 'sinatra/base'
require 'sinatra/flash'

module Sinatra
	module Auth
		module Helpers
			def authorized?
				session[:admin]
			end

			def protected!
				halt 401, erb(:unauthorized) unless authorized?
			end
		end

		def self.registered(app)
			app.helpers Helpers

			app.enable :sessions

			app.set :session_secret, '12345678900987654322345326576982757865241'

			app.set :username => 'bob', :password => 'olibob'

			app.get '/login' do
				erb :login
			end

			app.post '/login' do
				if params[:username] == settings.username && params[:password] == settings.password
					session[:admin] = true
					flash[:success] = "You are now logged in as #{settings.username}."
					redirect to('/songs')
				else
					flash[:danger] = "The user name or password you entered are incorrect."
					redirect to('/login')
				end
			end

			app.get '/logout' do
				session[:admin] = nil
				flash[:success] = "You are now logged out."
				redirect to('/')
			end

		end
	end

	register Auth
end