require 'songkick/transport'
module Services
  class SongkickApi
    class APIError < StandardError; end
    class << self
      API_KEY = ENV['SONGKICK_API_KEY']
      API_ENDPOINT = 'http://api.songkick.com/api/3.0'

      # Time limit: pull all gigs back to a certain date
      def gigography(username, time_limit = nil)
        events = []
        page = 1
        loop do
          response = get("/users/#{username}/gigography.json?order=desc&page=#{page}")
          raise APIError if data['resultsPage']['status'] == 'error'

          results = response.data['resultsPage']['results']
          events += results['event'].map do |event_hash|
            Event.new(event_hash)
          end
          max_events = results['totalEntries']

          break unless get_next_page?(events, max_events, time_limit)
          page += 1
        end
      end

      def get(endpoint)
        begin
          url = endpoint << "&apikey=#{API_KEY}"
          http.get(url)
        rescue Songkick::Transport::HttpError => e
          error = e.data['resultsPage']['error']
          raise APIError(error)
        end
      end

      def http
        Songkick::Transport::HttParty.new(API_ENDPOINT, :timeout => 10)
      end

      private

      def get_next_page?(events, max_events, time_limit = nil)
        # Keep going as no time limitation
        return true unless time_limit.present?
        # Got then all already
        return false if events.length == max_events
        # If oldest event in this batch is before the date limit, return false
        return events.last.date < time_limit
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
        .map { |performance| performance['artist']['displayName'] }
      end
    end
  end
end
