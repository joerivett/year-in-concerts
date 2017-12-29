module ViewModels
  class Playlist
    def initialize(playlist)
      @playlist = playlist
    end

    def errors?
      @playlist.errors.any?
    end

    def error_content
      @playlist.errors.first
    end
  end
end
