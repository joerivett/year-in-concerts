module ViewModels
  class Index
    def initialize(spotify_auth, params)
      @spotify_auth = JSON.parse(Base64.decode64(spotify_auth)) if spotify_auth.present?
      @params = params
    end

    def existing_errors
      case @params[:error]
      when 'spotify_access_denied'
        'You need to connect to your Spotify account to use this app'
      else
        ''
      end
    end

    def linked_spotify?
      @spotify_auth.present?
    end

    def spotify_username
      return '' unless @spotify_auth.present?

      @spotify_username ||= begin
        username = @spotify_auth['id']

        # Sometimes ID is an integer, sometimes it's the username
        # If integer, return full name
        unless (username.to_s =~ /^[0-9]+$/).nil?
          username = spotify_info['display_name'] rescue ''
        end

        username
      end
    end

    def has_spotify_image?
      spotify_image.length > 0
    end

    def spotify_image
      @spotify_image ||= begin
        return '' unless @spotify_auth.present?

        spotify_images = spotify_info.fetch('images', [])

        return '' unless spotify_images.any?

        spotify_images.first['url']
      end
    end

    private

    def spotify_info
      @spotify_info ||= @spotify_auth['info']
    end
  end
end
