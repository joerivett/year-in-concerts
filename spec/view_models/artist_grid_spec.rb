require 'spec_helper'

describe ViewModels::ArtistGrid do
  def mock_array(length)
    Array.new(length, :mock_artist) # array of given length where each element has value :mock_artist
  end

  subject do
    described_class.new(artists)
  end

  describe '#artist_cells' do
    context 'when the number of artists to show is not a square number' do
      let(:artists) { mock_array(11) }

      it 'pads the array with blanks until it is a square number in length' do
        cells = subject.artist_cells
        expect(cells.length).to eq(16)
        expect(cells.select(&:nil?).length).to eq(5)
      end
    end

    context 'when the number of artists to show is already a square number' do
      let(:artists) { mock_array(25) }

      it 'does not inject any blanks' do
        expect(subject.artist_cells.length).to eq(25)
      end
    end

    context 'when there are more than 36 artists to show' do
      let(:artists) { mock_array(50) }

      it 'only shows 36 artist' do
        expect(subject.artist_cells.length).to eq(36)
      end

      it 'does not include any blanks' do
        expect(subject.artist_cells.select(&:nil?).length).to eq(0)
      end
    end
  end
end
