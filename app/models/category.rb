class Category < ApplicationRecord
  has_many :recipes, through: :recipe_categories
  has_many :recipe_categories

  validates :name, length: {minimum: 3, maximum: 30}, uniqueness: true
end
