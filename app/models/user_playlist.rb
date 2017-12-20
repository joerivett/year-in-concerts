class UserPlaylist
  def initialize(username)
    @username = username
    p artist_names
  end

  def artist_names
    @artist_names ||= begin
      response = ::Services::SongkickApi.gigography(@username)
      return nil unless response.present?
      data = response.data
      return nil if data["resultsPage"]["status"] == "error"
      events = data["resultsPage"]["results"]["event"]
      events.reject! { |event| event["type"] == "Festival" }
      events.map do |event|
        headliners_for event
      end.flatten
    end
  end

  private

  def headliners_for(event)
    event["performance"]
    .reject { |performance| performance["billing"] == "support" }
    .map { |performance| performance["artist"]["displayName"] }
  end
end
