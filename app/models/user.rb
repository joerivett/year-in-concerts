class User
  class NoEventsError < StandardError; end
  class NoEventsInPastYearError < StandardError; end

  attr_reader :sk_username

  def initialize(sk_username)
    @sk_username = sk_username
  end

  def previous_year_concerts
    @past_year_concerts ||= begin
      raise NoEventsError unless concerts.length > 0

      # Only get concerts in 2018
      concerts.select! do |concert|
        concert.date.year == 2018
      end
      raise NoEventsInPastYearError unless concerts.length > 0
      concerts
    end
  end

  def concerts
    @concerts ||= events.reject(&:festival?)
  end

  def festivals
    @festivals ||= events.select(&:festival?)
  end

  def concert_count
    concerts.length
  end

  def festival_count
    festivals.length
  end

  private

  def events
    @events ||= ::Services::SongkickApi.gigography(@sk_username, Date.strptime('2018-01-01', '%Y-%m-%d'))
  end

end
