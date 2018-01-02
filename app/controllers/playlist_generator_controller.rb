require 'services/songkick_api'
require 'services/spotify_api'

class PlaylistGeneratorController < ApplicationController
  def index
    # UserPlaylist.new('rivett').build!
  end

  def create
    sk_username = params[:username]
    playlist = UserPlaylist.new(sk_username)
    playlist.build!

    playlist_view = ViewModels::Playlist.new(playlist)

    render :partial => 'playlist', :object => playlist_view
  end
end
