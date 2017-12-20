class UserPlaylist
  def initialize(username)
    @username = username
  end

  def build!
    p artist_names
    spotify = ::Services::SpotifyApi.new
    # Get headline artists of gigs and
    # Get Spotify artist ids
    spotify_artists = artist_names.map do |artist_name|
      spotify.get_artist(artist_name)
    end
    # p spotify_artists
    spotify_artists.reject!(&:nil?)
    # Get top tracks for each
    playlist_tracks = spotify_artists.map do |artist|
      spotify.top_tracks(artist, :GB)
    end
    
    p playlist_tracks.flatten.map(&:uri)
    # Create user playlist

    # Add to user playlist
  end

  # TODO: strip country suffix?
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
