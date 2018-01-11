require 'rspotify'
module Services
  class SpotifyApi
    CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
    CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

    def initialize(spotify_auth = nil)
      RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
      @spotify_auth = JSON.parse(Base64.decode64(spotify_auth)) if spotify_auth.present?
    end

    def get_artist(name, country=:GB)
      # TODO: country?
      artists = RSpotify::Artist.search(name, limit: 1, offset: 0, market: country)
      artists.first
    end

    def top_tracks(artist, country=:GB, max=3)
      tracks = artist.top_tracks(country)
      tracks.first(max)
    end

    def create_playlist(name)
      return unless @spotify_auth.present?
      # if playlist exists, delete it
      # RSpotify::Playlist.create(name)
      spotify_user = RSpotify::User.new(@spotify_auth)
      return spotify_user.create_playlist!(name, public: false)
    end

    def add_tracks_to_playlist(playlist, tracks)
      playlist.add_tracks!(tracks)
    end
  end
end
