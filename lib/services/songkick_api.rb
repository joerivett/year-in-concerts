require 'songkick/transport'
module Services
  class SongkickApi
    class APIError < StandardError; end
    class << self
      API_KEY = ENV['SONGKICK_API_KEY']
      API_ENDPOINT = 'https://api.songkick.com/api/3.0'

      # time_limit: pull all gigs back to a certain date
      def gigography(username, time_limit = nil)
        paginated_get("/users/#{username}/gigography.json?order=desc", Event, time_limit)
      end

      def tracked_artists(username)
        paginated_get("/users/#{username}/artists/tracked.json", Artist)
      end

      def paginated_get(url, klass, time_limit = nil)
        results = []
        page = 1
        resource_name = klass.name.demodulize.downcase
        loop do
          url += (url.include? "?") ? "&page=#{page}" : "?page=#{page}"
          response = get(url)
          raise APIError if response.data['resultsPage']['status'] == 'error'

          page_results = response.data['resultsPage']['results']
          break unless page_results[resource_name].present?

          results += page_results[resource_name].map do |resource_hash|
            klass.new(resource_hash)
          end
          max_results = response.data['resultsPage']['totalEntries'].to_i

          break unless get_next_page?(results, max_results, time_limit)
          page += 1
        end
        results
      end

      def get(endpoint)
        begin
          url = endpoint << "&apikey=#{API_KEY}"
          http.get(url)
        rescue Songkick::Transport::HttpError => e
          error = e.data['resultsPage']['error'].to_json
          raise APIError.new(error)
        end
      end

      def http
        Songkick::Transport::HttParty.new(API_ENDPOINT, :timeout => 10)
      end

      private

      def get_next_page?(results, max_results, time_limit = nil)
        # Got then all already
        return false if results.length == max_results
        # Keep going as no time limitation
        return true unless time_limit.present?
        # If oldest event in this batch is before the date limit, return true
        return results.last.date > time_limit
      end
    end
  end

  class Event
    def initialize(event_hash)
      @data = event_hash
    end

    def date
      @date ||= Date.strptime(@data['start']['date'], '%Y-%m-%d')
    end

    def festival?
      @data['type'] == 'Festival'
    end

    def headliners
      @headliners ||= begin
        @data['performance']
        .reject { |performance| performance['billing'] == 'support' }
        .map { |performance| Artist.new(performance['artist']) }
      end
    end
  end

  class Artist
    def initialize(artist_hash)
      @data = artist_hash
    end

    def name
      @data['displayName']
    end

    def id
      @data['id']
    end
  end
end
