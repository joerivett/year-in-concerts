module ViewModels
  class Playlist
    def initialize(playlist)
      @playlist = playlist
    end

    def link
      if @playlist.generated_playlist.present?
        "https://open.spotify.com/embed/user/#{@playlist.generated_playlist.owner.id}/playlist/#{@playlist.generated_playlist.id}"
      end
    end
    def errors?
      @playlist.errors.any?
    end

    def error_content
      @playlist.errors.first
    end
  end
end
