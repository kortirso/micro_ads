# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  subject { described_class }

  context 'valid parameters' do
    let(:ad_params) do
      {
        title:       'Ad title',
        description: 'Ad description',
        city:        'City',
        lat:         nil,
        lon:         nil,
        user_id:     '1'
      }
    end

    it 'creates a new ad' do
      expect { subject.call(ad_params) }
        .to change { Ad.count }.from(0).to(1)
    end

    it 'and assigns ad' do
      result = subject.call(ad_params)

      expect(result.ad).to be_kind_of(Ad)
    end
  end

  context 'invalid parameters' do
    let(:ad_params) do
      {
        title:       'Ad title',
        description: 'Ad description',
        city:        '',
        lat:         nil,
        lon:         nil,
        user_id:     '1'
      }
    end

    it 'does not create ad' do
      expect { subject.call(ad_params) }
        .not_to change(Ad, :count)
    end

    it 'and returns nil as ad' do
      result = subject.call(ad_params)

      expect(result.ad).to eq nil
    end
  end
end
