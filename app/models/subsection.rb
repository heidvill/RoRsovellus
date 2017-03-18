class Subsection < ApplicationRecord
  belongs_to :recipe, optional: true
  has_many :subsection_ingredients
  has_many :ingredients, through: :subsection_ingredients

  validates :title, length: {maximum: 30}

end
