require 'rails_helper'

RSpec.describe Frame, type: :model do
  let(:frame) { build(:frame) }

  it 'has a valid factory' do
    frame.valid?

    expect(frame).to be_valid
  end

  it { is_expected.to validate_presence_of(:x) }
  it { is_expected.to validate_presence_of(:y) }
  it { is_expected.to validate_presence_of(:width) }
  it { is_expected.to validate_presence_of(:height) }
  it { is_expected.to validate_numericality_of(:x) }
  it { is_expected.to validate_numericality_of(:y) }
  it { is_expected.to validate_numericality_of(:width) }
  it { is_expected.to validate_numericality_of(:height) }
  it { is_expected.to have_many(:circles) }

  context 'before validation' do
    let(:frame) { build(:frame, geometry: nil) }

    it "assigns attribute 'geometry' with oposits vertexs of frame" do
      left_vertex_x = frame.x - frame.width / 2.0
      left_vertex_y = frame.y - frame.height / 2.0
      right_vertex_x = frame.x + frame.width / 2.0
      right_vertex_y = frame.y + frame.height / 2.0
      geometry = "((#{left_vertex_x},#{left_vertex_y}),(#{right_vertex_x},#{right_vertex_y}))"

      expect{ frame.valid? }.to change { frame.geometry }.to(geometry)
    end
  end
end
