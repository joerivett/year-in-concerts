class User
  class NoEventsError < StandardError; end
  class NoEventsInPastYearError < StandardError; end

  attr_reader :sk_username

  def initialize(sk_username)
    @sk_username = sk_username
  end

  def previous_year_concerts
    @previous_year_concerts ||= previous_year_events.reject(&:festival?)
  end

  def previous_year_festivals
    @previous_year_festivals ||= previous_year_events.select(&:festival?)
  end

  def previous_year_venue_count
    @venue_count ||= previous_year_events.map { |event| event.venue['id'] }.uniq.count
  end

  def previous_year_concert_count
    previous_year_concerts.length
  end

  def previous_year_festival_count
    previous_year_festivals.length
  end

  def user_tracks_artist?(artist)
    tracked_artists.any? { |tracked_artist| tracked_artist.id == artist.id }
  end

  private

  def previous_year_events
    @previous_year_events ||= begin
      raise NoEventsError if gigography.length == 0

      # Only get events in 2018
      events = gigography.select do |event|
        event.date.year == 2018
      end

      raise NoEventsInPastYearError if events.length == 0
      events
    end
  end

  def gigography
    @gigography ||= ::Services::SongkickApi.gigography(@sk_username, Date.strptime('2018-01-01', '%Y-%m-%d'))
  end

  def tracked_artists
    @tracked_artists ||= ::Services::SongkickApi.tracked_artists(@sk_username)
  end

end
