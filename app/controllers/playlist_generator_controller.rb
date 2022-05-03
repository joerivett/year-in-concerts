require 'services/songkick_api'
require 'services/spotify_api'
require 'base64'
require 'json'

class PlaylistGeneratorController < ApplicationController
  before_action :enforce_xhr, only: [:create]

  helper_method :previous_year

  def index
    @page = ViewModels::Index.new(cookies[:spotify_auth], params)

    render :index
  end

  def create
    spotify_auth = cookies[:spotify_auth]
    sk_username = params[:username]

    user = User.new(sk_username)
    user_playlist = UserPlaylist.new(user, previous_year, spotify_auth)
    user_playlist.build!

    if user_playlist.errors?
      error_view = ViewModels::Error.new(user_playlist.errors)
      render partial: 'errors', object: error_view, status: :bad_request
    else
      playlist_view = ViewModels::Playlist.new(user_playlist)
      render partial: 'playlist', object: playlist_view, status: :ok
    end
  end

  # This is the callback action from Spotify once a user has authenticated with
  # Spotify and permitted this app to access to the requested scopes. At this point
  # we have an oauth token and can use this to make requests to the Spotify API.
  #
  # Initially the design of this method looks strange, since it stores a cookie
  # then redirects back to the index action. There is a reason for this:
  #
  # Since the UX is a 2-step process and the user next inputs their Songkick
  # username, it is necessary to record this oauth token for submission in the
  # subsquent request - this is achieved via a base64 encoded JSON cookie.
  # This is a code-smell: this is sensitive data so we should be using a cipher to
  # encrypt this hash when we write it into cookies. But since the oauth token
  # is signed against this app's client secret, it is useless to an attacker
  # unless they also somehow also accessed the secret
  def spotify
    return unless request.env['omniauth.auth'].present?

    auth = request.env['omniauth.auth']

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

  def previous_year
    @previous_year ||= (Date.current.beginning_of_year - 1.year).year
  end

  private

  def enforce_xhr
    unless request.xhr?
      error_view = ViewModels::Error.new(['Invalid request'])
      render(partial: 'errors', object: error_view, status: :bad_request) and return
    end
  end
end
