require 'spec_helper'
require 'rspec/rails'

describe PlaylistGeneratorController, :type => :controller do
  subject do
    described_class.new
  end

  describe 'POST create' do
    context 'when I attempt to violate the XHR-only policy' do
      it 'returns a 400 status code' do
        post :create
        expect(response.code.to_i).to eq(400)
      end
    end

    context 'when there are errors relating to the Songkick API' do
      let(:user_playlist) { double(UserPlaylist, :build! => '', :errors? => ['Invalid request']) }
      before { allow(UserPlaylist).to receive(:new).and_return(user_playlist) }

      it 'renders the error response' do
        expect(ViewModels::Error).to receive(:new)
        post :create
      end

      it 'returns an error HTTP status code' do
        post :create
        expect(response.code.to_i).to eq(400)
      end
    end
  end

  describe '#previous_year' do
    let(:current_date) { Time.local(2019, 12, 1) }
    before { travel_to current_date }
    after { travel_back }

    it 'returns January 1st of the previous year' do
      expect(subject.previous_year).to eq(2018)
    end

    context 'when a new year has just begun' do
      let(:current_date) { Time.local(2019, 1, 1, 0, 0, 0) }

      it 'returns January 1st of the previous year' do
        expect(subject.previous_year).to eq(2018)
      end
    end
  end
end
