require 'rails_helper'

RSpec.describe Circle, type: :model do
  let(:circle) { build(:circle) }

  it 'has a valid factory' do
    expect(circle).to be_valid
  end

  it { is_expected.to validate_presence_of(:x) }
  it { is_expected.to validate_presence_of(:y) }
  it { is_expected.to validate_presence_of(:radius) }
  it { is_expected.to validate_presence_of(:diameter) }
  it { is_expected.to validate_presence_of(:geometry) }
  it { is_expected.to validate_numericality_of(:x) }
  it { is_expected.to validate_numericality_of(:y) }
  it { is_expected.to validate_numericality_of(:radius).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:diameter).is_greater_than(0) }
  it { is_expected.to belong_to(:frame) }

  context 'before validation' do
    let(:circle) { build(:circle, radius: nil, geometry: nil) }

    it 'assigns attribute radius like half diameter' do
      expect{ circle.valid? }.to change{ circle.radius }.to(circle.diameter / 2.0)
    end

    it 'assigns attribute geometry' do
      geometry = "((#{circle.x},#{circle.y}),#{circle.diameter / 2.0})"

      expect{ circle.valid? }.to change{ circle.geometry }.to(geometry)
    end
  end
end
