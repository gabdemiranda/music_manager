class SongsController < ApplicationController
  skip_before_action :verify_authenticity_token

  @@mutex = Mutex.new

  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to @song, notice: "Song added successfully."
    else
      render :new, alert: "Failed to add song."
    end
  end

  def create_multiple
    threads = []
    sample_songs = [
      { title: "Song A", artist: "Artist A", album: "Album A", duration: 180, genre: "Rock" },
      { title: "Song B", artist: "Artist B", album: "Album B", duration: 210, genre: "Pop" },
      { title: "Song C", artist: "Artist C", album: "Album C", duration: 240, genre: "Jazz" }
    ]

    sample_songs.each do |song_param|
      threads << Thread.new do
        create_song(song_param)
      end
    end
    threads.each(&:join)
    redirect_to root_path, notice: "Multiple songs added successfully."
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @@mutex.synchronize do
      @song = Song.find(params[:id])
      if @song.update(song_params)
        redirect_to @song, notice: "Song updated successfully."
      else
        render :edit, alert: "Failed to update song."
      end
    end
  end

  def update_multiple
    threads = []
    selected_song_ids = params[:songs] || []

    selected_song_ids.each do |song_id|
      threads << Thread.new do
        @@mutex.synchronize do
          song = Song.find(song_id)
          song.update(title: "#{song.title} - Updated")
        end
      end
    end
    threads.each(&:join)
    redirect_to songs_path, notice: "Selected songs updated successfully."
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    redirect_to songs_path, notice: "Song deleted successfully."
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
