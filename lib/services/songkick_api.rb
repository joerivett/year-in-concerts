require 'songkick/transport'
module Services
  class SongkickApi
    class << self
      API_KEY = ENV['SONGKICK_API_KEY']
      API_ENDPOINT = 'http://api.songkick.com/api/3.0'

      def gigography(username)
        get("/users/#{username}/gigography.json")
      end

      def get(endpoint)
        begin
          url = endpoint << "?apikey=#{API_KEY}"
          http.get(url)
        rescue Songkick::Transport::HttpError => e
          error = e.data['resultsPage']['error']
          nil
        end
      end

      def http
        Songkick::Transport::HttParty.new(API_ENDPOINT, :timeout => 10)
      end
    end
  end
end
