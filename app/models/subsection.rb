class Subsection < ApplicationRecord
  belongs_to :recipe, optional: true
  has_many :subsection_ingredients
  accepts_nested_attributes_for :subsection_ingredients

  validates :title, length: {maximum: 30}

end
