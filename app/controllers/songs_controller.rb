class SongsController < ApplicationController
  @@mutex = Mutex.new

  def index
    @songs = Song.all
    render json: @songs
  end

  def show
    @song = Song.find(params[:id])
    render json: @song
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      render json: { status: "success", message: "Song added successfully.", song: @song }
    else
      render json: { status: "error", message: "Failed to add song." }
    end
  end

  def create_multiple
    threads = []
    songs_params.each do |song_param|
      threads << Thread.new do
        create_song(song_param)
      end
    end
    threads.each(&:join)
    render json: { status: "success", message: "Songs added successfully." }
  end

  def update
    @@mutex.synchronize do
      @song = Song.find(params[:id])
      if @song.update(song_params)
        render json: { status: "success", message: "Song updated successfully.", song: @song }
      else
        render json: { status: "error", message: "Failed to update song." }
      end
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    render json: { status: "success", message: "Song deleted successfully." }
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist, :album, :duration, :genre)
  end

  def songs_params
    params.require(:songs)
  end

  def create_song(song_params)
    Song.create(song_params)
  end
end
