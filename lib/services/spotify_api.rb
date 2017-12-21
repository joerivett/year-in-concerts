require 'rspotify'
module Services
  class SpotifyApi
    CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
    CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

    def initialize
      RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
    end

    def get_artist(name)
      # TODO: country?
      artists = RSpotify::Artist.search(name)
      artists.first
    end

    def top_tracks(artist, country=:GB, max=3)
      tracks = artist.top_tracks(country)
      tracks.first(max)
    end

    def create_playlist(name)
      RSpotify::Playlist.create(name)
    end

    def add_tracks_to_playlist(playlist, tracks)

    end
  end
end
