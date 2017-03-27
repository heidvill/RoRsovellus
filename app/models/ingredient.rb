class Ingredient < ApplicationRecord
  has_many :subsection_ingredients, dependent: :destroy

  validates :name, length: {minimum: 1, maximum: 30}
end
