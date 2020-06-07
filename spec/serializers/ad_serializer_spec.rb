# frozen_string_literal: true

RSpec.describe AdSerializer do
  subject { described_class.new(ad) }

  let(:ad) { create :ad }
  let(:serializer) { subject.serializable_hash.to_json }

  %w[title description city lat lon].each do |attr|
    it "serializer contains ad #{attr}" do
      expect(serializer).to have_json_path("data/attributes/#{attr}")
    end
  end
end
