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

  accepts_nested_attributes_for :circles, reject_if: :all_blank

  private

  def assigns_attribute_geometry_with_oposits_vertexs_of_frame
    return if [x, y, width, height].any?(&:blank?)

    left_vertex_x = x - width / 2.0
    left_vertex_y = y - height / 2.0
    right_vertex_x = x + width / 2.0
    right_vertex_y = y + height / 2.0

    self.geometry = "((#{left_vertex_x},#{left_vertex_y}),(#{right_vertex_x},#{right_vertex_y}))"
  end
end
