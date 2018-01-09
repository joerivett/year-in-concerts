require 'services/songkick_api'
require 'services/spotify_api'

class PlaylistGeneratorController < ApplicationController
  def index
    p request.env['omniauth.auth']
    # UserPlaylist.new('rivett').build!
  end

  def create
    p request.env['omniauth.auth']

    # sk_username = params[:username]
    # playlist = UserPlaylist.new(sk_username)
    # playlist.build!
    #
    # playlist_view = ViewModels::Playlist.new(playlist)

    render :partial => 'playlist', :object => playlist_view
  end

  def spotify
    return unless request.env['omniauth.auth'].present?

    auth = request.env['omniauth.auth']

    persist_hash = {}
    persist_hash['credentials'] = auth['credentials'].to_hash
    persist_hash['id'] = auth['uid']

    p persist_hash

    final_hash = persist_hash
    spotify_user3 = RSpotify::User.new(final_hash)
    p spotify_user3
    p spotify_user3.create_playlist!('Joe test2')

    redirect_to :root
  end
end
