class UserPlaylist
  class NoEventsError < StandardError; end
  class NoEventsInPastYearError < StandardError; end

  PLAYLIST_NAME = '2017 In Concerts'

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

    spotify_artists.reject!(&:nil?)
    # Get top tracks for each artist
    playlist_tracks = spotify_artists.map do |artist|
      spotify.top_tracks(artist, :GB)
    end

    # Create user playlist
    playlist = spotify.create_playlist(PLAYLIST_NAME)
    # Add to user playlist
    spotify.add_tracks_to_playlist(playlist, playlist_tracks.flatten.map(&:uri))
    p playlist_tracks.flatten.map(&:uri)

  end

  private

  # TODO: strip country suffix?
  def artist_names
    @artist_names ||= begin
      previous_year_concerts.map do |event|
        event.headliners
      end.flatten
    end
  end

  def previous_year_concerts
    @past_year_concerts || = begin
      events = user_concerts
      raise NoEventsError unless events.length > 0

      # Only get concerts in 2017
      events.reject! do |event|
        event.date.year == 2017
      end
      raise NoEventsInPastYearEror unless events.length > 0
      events
    end
  end

  def user_concerts
    events = ::Services::SongkickApi.gigography(@username, Date.strptime('2017-01-01', '%Y-%m-%d'))
    # Only concerts
    events.reject { |event| event.festival? }
  end


end
