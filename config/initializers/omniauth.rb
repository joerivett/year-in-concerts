require 'rspotify/oauth'
require 'services/spotify_api'

OmniAuth.config.on_failure = Proc.new do |env|
  PlaylistGeneratorController.action(:omniauth_failure).call(env)
end

Rails.application.config.to_prepare do
  OmniAuth::Strategies::Spotify.include SpotifyOmniauthExtension
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Services::SpotifyApi::CLIENT_ID, Services::SpotifyApi::CLIENT_SECRET, scope: 'playlist-modify-private'
end
