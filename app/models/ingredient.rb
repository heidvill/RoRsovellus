class Ingredient < ApplicationRecord
  has_many :subsection_ingredients

  validates :name, length: {minimum: 1, maximum: 30}
end
