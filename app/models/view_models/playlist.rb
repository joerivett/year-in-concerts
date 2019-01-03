module ViewModels
  class Playlist
    def initialize(playlist)
      @playlist = playlist
    end

    def embed_link
      if @playlist.generated_playlist.present?
        "https://open.spotify.com/embed/user/#{@playlist.generated_playlist.owner.id}/playlist/#{@playlist.generated_playlist.id}"
      end
    end

    def link
      if @playlist.generated_playlist.present?
        "https://open.spotify.com/user/#{@playlist.generated_playlist.owner.id}/playlist/#{@playlist.generated_playlist.id}"
      end
    end

    def playlist_size
      @playlist.generated_playlist.total
    end

    def errors?
      @playlist.errors.any?
    end

    def error_content
      @playlist.errors.first
    end

    def concert_count
      @playlist.user.concert_count
    end

    def festival_count
      @playlist.user.festival_count
    end
  end
end
