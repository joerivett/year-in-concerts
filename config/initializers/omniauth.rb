require 'rspotify/oauth'
require 'services/spotify_api'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Services::SpotifyApi::CLIENT_ID, Services::SpotifyApi::CLIENT_SECRET, scope: 'playlist-modify-private'
end
