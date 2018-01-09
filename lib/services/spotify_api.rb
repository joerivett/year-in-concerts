require 'rspotify'
module Services
  class SpotifyApi
    CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
    CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

    def initialize
      RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
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

    def get_user(username, token)

    end

    def create_playlist(username, name)
      # if playlist exists, delete it
      # RSpotify::Playlist.create(name)
    end

    def add_tracks_to_playlist(playlist, tracks)

    end
  end
end