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

    def summary
      overview = ""
      overview << "In 2018 you attended #{concert_count} #{'concert'.pluralize(concert_count)}"
      if festival_count > 0
        overview << " and #{festival_count} #{'festival'.pluralize(festival_count)}"
      end
      if venue_count > 1
        overview << ", at #{venue_count} different venues"
      end
      overview
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
      @playlist.user.previous_year_concert_count
    end

    def festival_count
      @playlist.user.previous_year_festival_count
    end

    def venue_count
      @playlist.user.previous_year_venue_count
    end

    def artist_grid
      ArtistGrid.new(@playlist.concert_headline_artists)
    end
  end
end
