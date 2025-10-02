class Frame < ApplicationRecord
  belongs_to :highest_circle, class_name: 'Circle',
                              optional: true
  belongs_to :lowest_circle, class_name: 'Circle',
                             optional: true
  belongs_to :rightest_circle, class_name: 'Circle',
                               optional: true
  belongs_to :leftest_circle, class_name: 'Circle',
                              optional: true

  has_many :circles, dependent: :destroy

  before_validation :assigns_attribute_geometry_with_oposits_vertexs_of_frame

  before_destroy :add_error_present_circles, prepend: true,
                                             if: proc { circles_count.positive? }

  validates :x, presence: true,
                numericality: true
  validates :y, presence: true,
                numericality: true
  validates :width, presence: true,
                    numericality: true
  validates :height, presence: true,
                     numericality: true
  validates :geometry, presence: true
  validates :highest_circle, presence: true,
                             if: proc { circles_count.positive? }
  validates :lowest_circle, presence: true,
                             if: proc { circles_count.positive? }
  validates :rightest_circle, presence: true,
                             if: proc { circles_count.positive? }
  validates :leftest_circle, presence: true,
                             if: proc { circles_count.positive? }

  validate :do_not_overlap_other_frame

  accepts_nested_attributes_for :circles, reject_if: :all_blank

  scope :overlap, ->(geometry) { where('frames.geometry && ?', geometry) }

  private

  def assigns_attribute_geometry_with_oposits_vertexs_of_frame
    return if [x, y, width, height].any?(&:blank?)

    left_vertex_x = x - width / 2.0
    left_vertex_y = y - height / 2.0
    right_vertex_x = x + width / 2.0
    right_vertex_y = y + height / 2.0

    self.geometry = "((#{left_vertex_x},#{left_vertex_y}),(#{right_vertex_x},#{right_vertex_y}))"
  end

  def add_error_present_circles
    errors.add(:circles, :present)
    throw :abort
  end

  def do_not_overlap_other_frame
    errors.add(:geometry, :overlap) if Frame.overlap(geometry).exists?
  end
end
