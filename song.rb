require 'dm-core'
require 'dm-migrations'

class Song
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :lyrics, Text
	property :length, Integer
	property :released_on, Date

	def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize


module SongHelpers
	def find_songs
		@songs = Song.all
	end

	def find_song
		Song.get(params[:id])
	end

	def create_song
		Song.create(params[:song])
	end
end

helpers SongHelpers

get '/songs' do
	@title = "SBS - All Songs"
	@song = find_songs
	erb :songs
end

get '/songs/new' do
	halt(401, 'Not authorized!') unless session[:admin]
	@song = Song.new
	erb :new_song
end

get '/songs/:id/edit' do
	halt(401, 'Not authorized!') unless session[:admin]
	@song = find_song
	erb :edit_song
end

delete '/songs/:id' do
	halt(401, 'Not authorized!') unless session[:admin]
	flash[:success] = "Song successfully deleted." if find_song.destroy
	redirect to('/songs')
end

get '/songs/:id' do
	@song = find_song
	erb :show_song
end

post '/songs' do
	song = create_song
	flash[:success] = "Song successfully added." if song
	redirect to("/songs/#{song.id}")
end

put '/songs/:id' do
	song = find_song
	flash[:success] = "Song successfully updated." if song.update(params[:song])
	redirect to("/songs/#{song.id}")
end