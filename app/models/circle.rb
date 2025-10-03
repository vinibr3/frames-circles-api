class Circle < ApplicationRecord
  belongs_to :frame, counter_cache: true

  before_validation :assigns_attributes

  after_save :update_positional_circles_of_frame

  before_destroy :destroy_positional_circles_of_frame, prepend: true

  validates :x, presence: true,
                numericality: true
  validates :y, presence: true,
                numericality: true
  validates :radius, presence: true,
                     numericality: { greater_than: 0 }
  validates :diameter, presence: true,
                       numericality: { greater_than: 0 }
  validates :geometry, presence: true

  validate :circle_do_not_overlap_other_circle_inside_same_frame
  validate :circle_contained_on_frame

  scope :boundry_positions,
    -> { select("MAX(y) AS max_y, MIN(y) AS min_y, MAX(x) AS max_x, MIN(x) AS min_x") }

  scope :overlap, ->(geometry) { where('circles.geometry && ?', geometry) }
  scope :contained, ->(geometry) { where('circles.geometry <@ ?', geometry) }
  scope :by_frame, ->(frame_id) { where(frame_id: frame_id) if frame_id.present? }

  private

  def assigns_attributes
    self.radius = self.diameter / 2.0 if diameter.present?
    self.geometry = "((#{x},#{y}),#{radius})" if [x, y, radius].all?(&:present?)
  end

  def update_positional_circles_of_frame
    frame.highest_circle = [frame.highest_circle, self].compact.sort_by(&:y).last
    frame.lowest_circle = [frame.lowest_circle, self].compact.sort_by(&:y).first
    frame.rightest_circle = [frame.rightest_circle, self].compact.sort_by(&:x).last
    frame.leftest_circle = [frame.leftest_circle, self].compact.sort_by(&:x).first

    frame.save!
  end

  def destroy_positional_circles_of_frame
    frame.highest_circle = available_circles.find_by(y: boundry_positions.max_y) if frame.highest_circle == self
    frame.lowest_circle = available_circles.find_by(y: boundry_positions.min_y) if frame.lowest_circle == self
    frame.rightest_circle = available_circles.find_by(x: boundry_positions.max_x) if frame.rightest_circle == self
    frame.leftest_circle = available_circles.find_by(x: boundry_positions.min_x) if frame.leftest_circle == self

    frame.save(validate: false)
  end

  def boundry_positions
    @frame_boundry_positions ||= available_circles.boundry_positions[0]
  end

  def available_circles
    frame.circles.where.not(id: id)
  end

  def circle_do_not_overlap_other_circle_inside_same_frame
    errors.add(:geometry, :overlap) if Circle.where.not(id: id)
                                             .where(frame_id: frame_id)
                                             .overlap(geometry)
                                             .exists?
  end

  def circle_contained_on_frame
    variables = [y, x, radius, frame.try(:x), frame.try(:y), frame.try(:height), frame.try(:width)]
    return if variables.any?(&:blank?)

    circle_max_y = y + radius
    circle_min_y = y - radius
    circle_max_x = x + radius
    circle_min_x = x - radius
    frame_max_y = frame.y + frame.height / 2.0
    frame_min_y = frame.y - frame.height / 2.0
    frame_max_x = frame.x + frame.width / 2.0
    frame_min_x = frame.x - frame.width / 2.0

    return if circle_max_y <= frame_max_y &&
              circle_min_y >= frame_min_y &&
              circle_max_x <= frame_max_x &&
              circle_min_x >= frame_min_x

    errors.add(:geometry, :out_frame)
  end
end
