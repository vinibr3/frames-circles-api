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
  it { is_expected.to have_db_index(:x) }
  it { is_expected.to have_db_index(:y) }

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

  context 'after save' do
    let(:frame) { create(:frame, highest_circle: nil,
                                 lowest_circle: nil,
                                 rightest_circle: nil,
                                 leftest_circle: nil) }

    it 'updates positional circles of frame' do
      highest_circle = create(:circle, frame: frame, x: frame.x, y: frame.y + 2, diameter: 1)
      lowest_circle = create(:circle, frame: frame, x: frame.x, y: frame.y - 2, diameter: 1)
      rightest_circle = create(:circle, frame: frame, x: frame.x + 2, y: frame.y, diameter: 1)
      leftest_circle = create(:circle, frame: frame, x: frame.x - 2, y: frame.y, diameter: 1)

      positional_circles_of_frame =
        [frame.reload.highest_circle, frame.lowest_circle, frame.rightest_circle, frame.leftest_circle]

      expect(positional_circles_of_frame).to eq([highest_circle, lowest_circle,
                                                 rightest_circle, leftest_circle])
    end
  end

  context 'before destroy circle' do
    let(:frame) { create(:frame) }

    it 'destroy positional circles of frame' do
      highest_circle = create(:circle, frame: frame, x: frame.x, y: frame.y + 5, diameter: 1)
      lowest_circle = create(:circle, frame: frame, x: frame.x, y: frame.y - 5, diameter: 1)
      rightest_circle = create(:circle, frame: frame, x: frame.x + 5, y: frame.y, diameter: 1)
      leftest_circle = create(:circle, frame: frame, x: frame.x - 5, y: frame.y, diameter: 1)
      centerest_circle = create(:circle, frame: frame, x: frame.x, y: frame.y, diameter: 1)

      frame.update!(highest_circle: highest_circle,
                    lowest_circle: lowest_circle,
                    rightest_circle: rightest_circle,
                    leftest_circle: leftest_circle)

      frame.circles.where.not(id: centerest_circle.id).each(&:destroy)

      positional_circles_of_frame =
        [frame.reload.highest_circle, frame.lowest_circle, frame.rightest_circle, frame.leftest_circle]

      expect(positional_circles_of_frame).to all(eq(centerest_circle))
    end

    context 'when there are one circle only' do
      let(:frame) { create(:frame) }

      it 'destroy positional circles of frame' do
        circle = create(:circle, frame: frame, x: frame.x, y: frame.y, diameter: 1)

        frame.update!(highest_circle: circle,
                      lowest_circle: circle,
                      rightest_circle: circle,
                      leftest_circle: circle)

        circle.destroy

        positional_circles_of_frame =
          [frame.reload.highest_circle, frame.lowest_circle, frame.rightest_circle, frame.leftest_circle]

        expect(positional_circles_of_frame).to all be_nil
      end
    end
  end

  context 'when validate' do
    context 'with circle overlaping inside same frame' do
      let(:frame) { create(:frame) }
      let(:circle) { build(:circle, frame: frame, x: frame.x, y: frame.y, diameter: 10) }

      it "atribute 'geometry' has overlap error message" do
        create(:circle, frame: frame, x: frame.x, y: frame.y, diameter: 10)
        circle.valid?

        expect(circle.errors.full_messages).to include('Representação geométrica tem sobreposição')
      end
    end

    context 'with circle do not contained on frame' do
      let(:frame) { build(:frame, width: 1, height: 1) }
      let(:circle) { build(:circle, frame: frame, diameter: 1) }

      it "atribute 'geometry' has out_frame error message" do
        circle.valid?

        expect(circle.errors.full_messages).to include('Representação geométrica não está contida no quadro')
      end
    end
  end
end
