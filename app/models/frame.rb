class Frame < ApplicationRecord
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
