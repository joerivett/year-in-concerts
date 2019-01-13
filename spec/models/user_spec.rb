require 'spec_helper'

describe User do
  subject do
    described_class.new('username')
  end

  describe '#user_tracks_artist?' do
    let(:tracked_artist) { double('Artist', id: 1) }
    let(:untracked_artist) { double('Artist', id: 2) }

    before do
      allow(subject).to receive(:tracked_artists).and_return([tracked_artist])
    end

    context 'when the user tracks the artist' do
      it 'returns true' do
        expect(subject.user_tracks_artist? tracked_artist).to be(true)
      end
    end

    context 'when the user does not track the artist' do
      it 'returns false' do
        expect(subject.user_tracks_artist? untracked_artist).to be(false)
      end
    end
  end
end
