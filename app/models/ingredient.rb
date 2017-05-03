class Ingredient < ApplicationRecord
  has_many :subsection_ingredients, dependent: :destroy
  has_many :subsections, through: :subsection_ingredients
  has_many :recipes, through: :subsections

  validates :name, uniqueness:true, length: {minimum: 1, maximum: 30}
end
