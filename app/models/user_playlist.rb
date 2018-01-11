class UserPlaylist
  class NoEventsError < StandardError; end
  class NoEventsInPastYearError < StandardError; end

  PLAYLIST_NAME = '2017 In Concerts'

  attr_reader :errors, :generated_playlist

  def initialize(sk_username, spotify_auth)
    @sk_username = sk_username
    @spotify_auth = spotify_auth
    @errors = []
  end

  def build!
    if @sk_username.blank?
      @errors << "Please enter a username"
      return
    elsif @spotify_auth.blank?
      @errors << "Please connect to Spotify first"
      return
    end

    spotify = ::Services::SpotifyApi.new(@spotify_auth)

    spotify_artists = get_spotify_artists(spotify)
    playlist_tracks = get_top_tracks(spotify_artists, spotify)

    # Create user playlist
    @generated_playlist = build_playlist(playlist_tracks, spotify)
  rescue NoEventsError => e
    @errors << "Looks like you haven't marked your attendance on any Songkick events"
  rescue NoEventsInPastYearError => e
    @errors << "Looks like you haven't been to any events in the past year"
  end

  private

  # Get Spotify artist ids
  def get_spotify_artists(spotify)
    spotify_artists = artist_names.reverse.map do |artist_name|
      spotify.get_artist(artist_name)
    end

    spotify_artists.reject(&:nil?)
  end

  # Get top tracks for each artist
  def get_top_tracks(spotify_artists, spotify)
    spotify_artists.map do |artist|
      spotify.top_tracks(artist, :GB)
    end
  end

  def build_playlist(playlist_tracks, spotify)
    playlist = spotify.create_playlist(PLAYLIST_NAME)
    # Add to user playlist
    spotify.add_tracks_to_playlist(playlist, playlist_tracks.flatten.map(&:uri))
    playlist
  end

  # Get headline artists of gigs attended
  # TODO: strip country suffix?
  def artist_names
    @artist_names ||= begin
      previous_year_concerts.map do |event|
        event.headliners
      end.flatten
    end
  end

  def previous_year_concerts
    @past_year_concerts ||= begin
      events = user_concerts
      raise NoEventsError unless events.length > 0

      # Only get concerts in 2017
      events.select! do |event|
        event.date.year == 2017
      end
      raise NoEventsInPastYearError unless events.length > 0
      events
    end
  end

  def user_concerts
    events = ::Services::SongkickApi.gigography(@sk_username, Date.strptime('2017-01-01', '%Y-%m-%d'))
    # Only concerts
    events.reject { |event| event.festival? }
  end

end
