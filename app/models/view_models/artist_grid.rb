module ViewModels
  class ArtistGrid
    def initialize(artists)
      # Max 36, so never more than a 6x6 grid
      @artists = artists.first(36)
    end

    def artist_cells
      cells = @artists
      # Backfill array with empty cells if not enough artists to fill the grid
      cells << nil while cells.length < grid_size ** 2
      cells.shuffle!
    end

    def cell_width
      @cell_width ||= 100 / grid_size
    end

    def background_image_for(cell_artist)
      return 'none' unless cell_artist.present?
      "url(https://images.sk-static.com/images/media/profile_images/artists/#{cell_artist.id}/large_avatar)"
    end

    def title_for(cell_artist)
      return '' unless cell_artist.present?
      cell_artist.name
    end

    COLOURS = ['#F50F4A', '#FF6F59', '#254441', '#43AA8B', '#B2B09B', '#4056F4'].freeze
    def random_colour
      COLOURS.sample
    end

    private

    def grid_size
      @grid_size ||= Math.sqrt(@artists.length).ceil
    end
  end
end
