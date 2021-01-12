module ViewModels
  class Playlist
    def initialize(playlist)
      @playlist = playlist
    end

    def embed_link
      return '' unless @playlist.generated_playlist.present?

      "https://open.spotify.com/embed/playlist/#{@playlist.generated_playlist.id}"
    end

    def link
      return '' unless @playlist.generated_playlist.present?

      "https://open.spotify.com/playlist/#{@playlist.generated_playlist.id}"
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
      @playlist.user.number_of_concerts_attended_in_year(@playlist.playlist_year)
    end

    def festival_count
      @playlist.user.number_of_festivals_attended_in_year(@playlist.playlist_year)
    end

    def venue_count
      @playlist.user.venues_attended_in_year(@playlist.playlist_year)
    end

    def artist_grid
      ArtistGrid.new(@playlist.concert_headline_artists)
    end
  end
end
