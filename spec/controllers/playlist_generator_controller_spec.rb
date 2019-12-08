require 'spec_helper'

describe PlaylistGeneratorController, :type => :controller do
  subject do
    described_class.new
  end

  describe '#last_year' do
    let(:current_date) { Time.local(2019, 12, 1) }
    before { travel_to current_date }
    after { travel_back }

    it 'returns January 1st of the previous year' do
      expect(subject.last_year).to eq(2018)
    end

    context 'when a new year has just begun' do
      let(:current_date) { Time.local(2019, 1, 1, 0, 0, 0) }

      it 'returns January 1st of the previous year' do
        expect(subject.last_year).to eq(2018)
      end
    end
  end
end
