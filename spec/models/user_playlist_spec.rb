require 'spec_helper'

describe UserPlaylist do
  subject do
    described_class.new(user, nil)
  end

  describe '#concert_headline_artists' do
    let(:tracked_artist) { double('Artist', id: 1) }
    let(:untracked_artist) { double('Artist', id: 2) }
    let(:event) { double('Event', headliners: [tracked_artist, untracked_artist]) }
    let(:user) { double(User, previous_year_concerts: [event]) }

    before do
      allow(subject).to receive(:user).and_return(user)
      allow(user).to receive(:user_tracks_artist?).with(tracked_artist).and_return(true)
      allow(user).to receive(:user_tracks_artist?).with(untracked_artist).and_return(false)
    end

    context 'when the user tracks a headliner' do
      it 'includes the tracked artist' do
        expect(subject.__send__(:concert_headline_artists)).to include(tracked_artist)
      end

      it 'does not include the untracked headliners' do
        expect(subject.__send__(:concert_headline_artists)).not_to include(untracked_artist)
      end
    end

    context 'when the user does not track any headliners' do
      before do
        allow(user).to receive(:user_tracks_artist?).and_return(false)
      end

      it 'includes all the headliners on the lineup' do
        expect(subject.__send__(:concert_headline_artists)).to match_array(event.headliners)
      end
    end

    context 'when the user has seen the same artist multiple times in the year' do
      let(:event_2) { double('Event', headliners: [tracked_artist]) }
      let(:user) { double(User, previous_year_concerts: [event, event_2]) }

      it 'only includes the artist once' do
        artists = subject.__send__(:concert_headline_artists)
        expect(artists.length).to eq(1)
        expect(artists.first).to eq(tracked_artist)
      end
    end

    context 'when the user seen different artists over the year' do
      let(:artist) { double('Artist', id: 3) }
      let(:artist_2) { double('Artist', id: 4) }
      let(:event_2) { double('Event', headliners: [artist]) }
      let(:event_3) { double('Event', headliners: [artist_2]) }
      # Note the order of events in previous_year_concerts. The Songkick API
      # returns gigography events in order of recency (most recent first)
      let(:user) { double(User, previous_year_concerts: [event_3, event_2, event]) }

      before do
        allow(user).to receive(:user_tracks_artist?).with(artist).and_return(false)
        allow(user).to receive(:user_tracks_artist?).with(artist_2).and_return(false)
      end

      it 'returns artists in the order in which they were seen' do
        artists = subject.__send__(:concert_headline_artists)
        expect(artists.length).to eq(3)
        expect(artists[0]).to eq(tracked_artist)
        expect(artists[1]).to eq(artist)
        expect(artists[2]).to eq(artist_2)
      end
    end
  end
end
