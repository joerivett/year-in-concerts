module ViewModels
  class Index
    def initialize(spotify_auth)
      @spotify_auth = JSON.parse(Base64.decode64(spotify_auth)) if spotify_auth.present?
      spotify_username
    end

    def step_1?
      !have_linked_spotify?
    end

    def spotify_username
      return '' unless @spotify_auth.present?
      @spotify_auth['id']
    end

    def has_spotify_image?
      spotify_image.length > 0
    end

    def spotify_image
      @spotify_image ||= begin
        return '' unless @spotify_auth.present?
        return '' unless @spotify_auth['info']['images'].present? && @spotify_auth['info']['images'].any?
        @spotify_auth['info']['images'].first['url']
      end
    end

  private

    def have_linked_spotify?
      @spotify_auth.present?
    end
  end
end
