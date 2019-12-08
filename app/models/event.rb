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

  def venue
    @data['venue']
  end

  def headliners
    @headliners ||= begin
      @data['performance']
      .reject { |performance| performance['billing'] == 'support' }
      .map { |performance| Artist.new(performance['artist']) }
    end
  end
end
