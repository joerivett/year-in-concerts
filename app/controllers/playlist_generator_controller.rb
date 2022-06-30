require 'services/songkick_api'
require 'services/spotify_api'
require 'base64'
require 'json'

class PlaylistGeneratorController < ApplicationController
  helper_method :last_year

  def index
    @page = ViewModels::Index.new(cookies[:spotify_auth], params)

    render :index
  end

  def create
    spotify_auth = cookies[:spotify_auth]
    sk_username = params[:username]
    user = User.new(sk_username)
    playlist = UserPlaylist.new(user, last_year, spotify_auth)
    playlist.build!

    playlist_view = ViewModels::Playlist.new(playlist)

    status = playlist_view.errors? ? 417 : 200
    render partial: 'playlist', object: playlist_view, status: status
  end

  def spotify
    p est.env['omniauth.auth'].present?
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

  def omniauth_failure
    redirect_to "#{root_path}?error=spotify_access_denied"
  end

  def last_year
    @last_year ||= (Date.current.beginning_of_year - 1.year).year
  end
end
