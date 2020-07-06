# frozen_string_literal: true

RSpec.describe AuthHttpService::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:headers) { { 'Content-Type' => 'application/json' } }

  before do
    stubs.get('verify_token') { [status, headers, body.to_json] }
  end

  context 'for nil request' do
    let(:status) { 403 }
    let(:errors) { [{ 'detail' => 'Forbidden' }] }
    let(:body) { { 'errors' => errors } }

    it 'returns nil' do
      expect(subject.auth(nil)).to be_nil
    end
  end

  context 'for invalid response' do
    let(:status) { 403 }
    let(:errors) { [{ 'detail' => 'Forbidden' }] }
    let(:body) { { 'errors' => errors } }

    it 'returns nil' do
      expect(subject.auth('invalid')).to be_nil
    end
  end

  context 'for valid response' do
    let(:status) { 200 }
    let(:user_id) { 1 }
    let(:body) { { 'user_id' => user_id } }

    it 'returns user_id' do
      expect(subject.auth('valid')).to eq user_id
    end
  end
end
