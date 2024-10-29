require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) do
    {
      city: 'Katowice',
      country: 'Poland',
      latitude: 50.264893,
      longitude: 19.023781,
      ip: '46.242.241.35',
      url: 'www.katowice.pl'
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }

    context 'when url is blank' do
      before { subject.url = nil }

      it 'validates presence of ip' do
        expect(subject).to validate_presence_of(:ip)
      end
    end

    context 'when ip is blank' do
      before { subject.ip = nil }

      it 'validates presence of url' do
        expect(subject).to validate_presence_of(:url)
      end
    end
  end
end
