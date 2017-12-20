require 'services/songkick_api'
require 'services/spotify_api'

class PlaylistGeneratorController < ApplicationController
  def index
    UserPlaylist.new('rivett').build!
  end

  def create
    username = params[:username]

    UserPlaylist.new(username)
  end
end
