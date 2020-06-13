# frozen_string_literal: true

RSpec.describe GeocoderService::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:headers) { { 'Content-Type' => 'application/json' } }

  before do
    stubs.get('geocode') { [status, headers, body.to_json] }
  end

  context 'for nil request' do
    let(:status) { 400 }
    let(:errors) { [{ 'detail' => 'Geocoding error' }] }
    let(:body) { { 'errors' => errors } }

    it 'returns coordinates' do
      expect(subject.geocode(nil)).to be_nil
    end
  end

  context 'for invalid response' do
    let(:status) { 400 }
    let(:errors) { [{ 'detail' => 'Geocoding error' }] }
    let(:body) { { 'errors' => errors } }

    it 'returns coordinates' do
      expect(subject.geocode('Москва')).to be_nil
    end
  end

  context 'for valid response' do
    let(:status) { 200 }
    let(:coordinates) { [55.7540471, 37.620405] }
    let(:body) { { 'coordinates' => coordinates } }

    it 'returns coordinates' do
      expect(subject.geocode('Москва')).to eq coordinates
    end
  end
end
