# frozen_string_literal: true

describe Api::V1, type: :routes do
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
      parsed_body = response_body.dig('ads', 'data')

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
    let(:geocoder_service) { instance_double('Client') }
    let(:auth_service) { instance_double('Client') }

    before do
      allow(GeocoderService::Client).to receive(:new).and_return(geocoder_service)
      allow(AuthRpcService::RpcClient).to receive(:fetch).and_return(auth_service)
    end

    context 'with invalid params' do
      let(:user_id) { 1 }
      let(:params) { { ad: { title: '', description: '2', city: '3' }, token: '111' }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/ads', params, headers }

      before do
        allow(geocoder_service).to receive(:geocode).and_return(nil)
        allow(auth_service).to receive(:verify_token).and_return(user_id)
      end

      it 'does not create ad' do
        expect { request }.not_to change(Ad, :count)
      end

      context 'in response' do
        before { request }

        it 'returns error status' do
          expect(last_response.status).to eq(400)
        end

        it 'and returns error message' do
          expect(response_body['errors']).not_to eq nil
        end
      end
    end

    context 'with invalid token' do
      let(:user_id) { nil }
      let(:coordinates) { [1, 2] }
      let(:params) { { ad: { title: '1', description: '2', city: '3' }, token: '111' }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/ads', params, headers }

      before do
        allow(geocoder_service).to receive(:geocode).and_return(coordinates)
        allow(auth_service).to receive(:verify_token).and_return(user_id)
      end

      it 'does not create ad' do
        expect { request }.not_to change(Ad, :count)
      end

      context 'in response' do
        before { request }

        it 'returns error status' do
          expect(last_response.status).to eq(403)
        end

        it 'and returns error message' do
          expect(response_body['errors']).not_to eq nil
        end
      end
    end

    context 'with valid params and token' do
      let(:user_id) { 1 }
      let(:city) { 'City' }
      let(:coordinates) { [1, 2] }
      let(:params) { { ad: { title: '1', description: '2', city: city }, token: '111' }.to_json }
      let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
      let(:request) { post '/api/v1/ads', params, headers }

      before do
        allow(geocoder_service).to receive(:geocode).and_return(coordinates)
        allow(auth_service).to receive(:verify_token).and_return(user_id)
      end

      it 'creates ad' do
        expect { request }.to change { Ad.count }.by(1)
      end

      context 'in response' do
        before { request }

        it 'returns success status' do
          expect(last_response.status).to eq(201)
        end

        it 'and returns serialized ad' do
          %w[title description city lat lon].each do |attr|
            expect(last_response.body).to have_json_path("ad/data/attributes/#{attr}")
          end
        end
      end
    end
  end
end
