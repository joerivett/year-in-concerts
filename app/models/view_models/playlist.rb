module ViewModels
  class Playlist
    def initialize(playlist)
      @playlist = playlist
    end

    def embed_link
      return '' unless @playlist.generated_playlist.present?

      "https://open.spotify.com/embed/user/#{@playlist.generated_playlist.owner.id}/playlist/#{@playlist.generated_playlist.id}"
    end

    def link
      return '' unless @playlist.generated_playlist.present?

      "https://open.spotify.com/user/#{@playlist.generated_playlist.owner.id}/playlist/#{@playlist.generated_playlist.id}"
    end

    def summary
      overview = ''
      overview << "In #{@playlist.playlist_year} you attended #{concert_count} #{'concert'.pluralize(concert_count)}"
      if festival_count > 0
        overview << " and #{festival_count} #{'festival'.pluralize(festival_count)},"
      end
      if venue_count > 1
        overview << " at #{venue_count} different venues"
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
