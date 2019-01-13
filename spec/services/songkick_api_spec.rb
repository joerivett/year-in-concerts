require 'spec_helper'
require 'services/songkick_api'

describe Services::SongkickApi do
  subject { described_class }

  let(:total_entries) { 1 }

  let(:first_page) do
    {
      'resultsPage' => {
        'results' => {
          'event' => [
            {
              'id' => 1,
              'displayName' => 'Radiohead at the O2'
            }
          ]
        },
        'totalEntries' => total_entries
      }
    }
  end

  let(:response) { double(Songkick::Transport::Response, data: first_page) }

  class Event
    def initialize(response)
    end
  end


  before do
    allow(subject).to receive(:get).and_return(response)
  end

  describe '.paginated_get' do
    context 'when there is only a single page of results' do
      let(:total_entries) { 1 }
      it 'calls only makes one request' do
        expect(subject).to receive(:get)
          .once
        subject.paginated_get('/endpoint', Event)
      end
    end

    context 'when there are multiple pages of results' do
      let(:total_entries) { 2 }
      it 'calls only makes one request' do
        expect(subject).to receive(:get)
          .twice
        subject.paginated_get('/endpoint', Event)
      end
    end

    it 'instantiates the supplied class based on results' do
      expect(Event).to receive(:new)
      subject.paginated_get('/endpoint', Event)
    end

    context 'when there is an error response from the Songkick API' do
      let(:first_page) do
        {
          'resultsPage' => {
            'status' => 'error'
          }
        }
      end

      it 'raises an APIError' do
        expect {
          subject.paginated_get('/endpoint', Event)
        }.to raise_error(Services::SongkickApi::APIError)
      end
    end
  end
end
