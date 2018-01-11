require 'services/songkick_api'
require 'services/spotify_api'
require 'base64'
require 'json'

class PlaylistGeneratorController < ApplicationController
  def index
    # if cookies[:spotify_auth].present?
    #   spotify_auth = JSON.parse(Base64.decode64(cookies[:spotify_auth]))
    #
    #   p :spotify_auth
    #   p spotify_auth
    #
    #   spotify_user = RSpotify::User.new(spotify_auth)
    #   p spotify_user
    # end

    @page = ViewModels::Index.new(cookies[:spotify_auth])

    render :index
  end

  def create
    spotify_auth = cookies[:spotify_auth]
    sk_username = params[:username]
    playlist = UserPlaylist.new(sk_username, spotify_auth)
    playlist.build!

    playlist_view = ViewModels::Playlist.new(playlist)

    render :partial => 'playlist', :object => playlist_view
  end

  def spotify
    return unless request.env['omniauth.auth'].present?

    auth = request.env['omniauth.auth']

        p auth
    persist_hash = {}
    persist_hash['credentials'] = auth['credentials'].to_hash
    persist_hash['info'] = auth['info']
    persist_hash['id'] = auth['uid']


    cookies[:spotify_auth] = Base64.encode64(persist_hash.to_json)

    redirect_to :root
  end
end
