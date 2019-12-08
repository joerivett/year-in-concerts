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
