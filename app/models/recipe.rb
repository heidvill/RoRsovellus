class Recipe < ApplicationRecord
  has_many :subsections
  has_many :subsection_ingredients, through: :subsections
  has_many :ingredients, through: :subsections, source: :subsection_ingredients
  accepts_nested_attributes_for :subsections
  #accepts_nested_attributes_for :subsection_ingredients
  #accepts_nested_attributes_for :ingredients

  validates :name, length: {minimum: 3, maximum: 30}
  validates :description, length: {minimum: 3, maximum: 1500}
  validates :amount, numericality: {greater_than_or_equal_to: 1, only_integer: true}
  validates :time, numericality: {greater_than_or_equal_to: 1}

end
