# frozen_string_literal: true

describe Api::V1 do
  include Rack::Test::Methods

  def app
    Api::V1
  end

  context 'GET /api/v1' do
    it 'returns version of api' do
      get '/api/v1'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['version']).to eq 'v1'
    end
  end

  context 'GET /api/v1/ads' do
    let!(:ad) { create :ad }

    before { get '/api/v1/ads' }

    it 'returns success status' do
      expect(last_response.status).to eq(200)
    end

    it 'and returns ads list' do
      parsed_body = JSON.parse(last_response.body).dig('ads', 'data')

      expect(parsed_body.size).to eq 1
      expect(parsed_body[0].fetch('id')).to eq ad.id.to_s
    end

    it 'and ads are serialized' do
      %w[title description city lat lon].each do |attr|
        expect(last_response.body).to have_json_path("ads/data/0/attributes/#{attr}")
      end
    end
  end

  context 'POST /api/v1/ads' do
    context 'with valid params' do
      let(:params) { { ad: { title: '1', description: '2', city: '3' }, user_id: 1 }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/ads', params, headers }

      it 'creates ad' do
        expect { request }.to change { Ad.count }.by(1)
      end

      context 'in response' do
        before { request }

        it 'returns success status' do
          expect(last_response.status).to eq(201)
        end

        it 'and ad is serialized' do
          %w[title description city lat lon].each do |attr|
            expect(last_response.body).to have_json_path("ad/data/attributes/#{attr}")
          end
        end
      end
    end
  end
end
