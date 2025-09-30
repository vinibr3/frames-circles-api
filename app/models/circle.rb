class Circle < ApplicationRecord
  belongs_to :frame

  before_validation :assigns_attributes

  validates :x, presence: true,
                numericality: true
  validates :y, presence: true,
                numericality: true
  validates :radius, presence: true,
                     numericality: { greater_than: 0 }
  validates :diameter, presence: true,
                       numericality: { greater_than: 0 }
  validates :geometry, presence: true

  def assigns_attributes
    self.radius = self.diameter / 2.0 if diameter.present?
    self.geometry = "((#{x},#{y}),#{radius})" if [x, y, radius].all?(&:present?)
  end
end
