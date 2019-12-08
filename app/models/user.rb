class User
  class NoEventsError < StandardError; end
  class NoEventsInPastYearError < StandardError; end

  attr_reader :sk_username

  def initialize(sk_username)
    @sk_username = sk_username
  end

  def concerts_attended_in_year(year)
    @concerts_attended ||= Hash.new do |hash, year|
      hash[year] = events_attended_in_year(year).reject(&:festival?)
    end
    @concerts_attended[year]
  end

  def festivals_attended_in_year(year)
    @festivals_attended ||= Hash.new do |hash, year|
      hash[year] = events_attended_in_year(year).select(&:festival?)
    end
    @festivals_attended[year]
  end

  def venues_attended_in_year(year)
    @venue_count ||= begin
      events = events_attended_in_year(year).map do |event|
        event.venue['id']
      end
      events.uniq.count
    end
  end

  def number_of_concerts_attended_in_year(year)
    concerts_attended_in_year(year).count
  end

  def number_of_festivals_attended_in_year(year)
    festivals_attended_in_year(year).count
  end

  def user_tracks_artist?(artist)
    tracked_artists.any? { |tracked_artist| tracked_artist.id == artist.id }
  end

  private

  def events_attended_in_year(year)
    @events_attended ||= Hash.new do |hash, year|
      gigography = gigography_for_year(year)
      raise NoEventsError if gigography.length == 0

      # Only get events in given year
      events = gigography.select do |event|
        event.date.year == year
      end

      raise NoEventsInPastYearError if events.length == 0
      hash[year] = events
    end
    @events_attended[year]
  end

  def gigography_for_year(year)
    @gigographies ||= Hash.new do |hash, year|
      hash[year] = ::Services::SongkickApi.gigography(@sk_username, Date.strptime("#{year}-01-01", '%Y-%m-%d'))
    end
    @gigographies[year]
  end

  def tracked_artists
    @tracked_artists ||= ::Services::SongkickApi.tracked_artists(@sk_username)
  end

end
