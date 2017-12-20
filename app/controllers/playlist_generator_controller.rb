require 'services/songkick_api'
class PlaylistGeneratorController < ApplicationController
  def index
    UserPlaylist.new('rivett')
  end
end
