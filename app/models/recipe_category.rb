class RecipeCategory < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :category, optional: true

  validates :recipe_id, presence: true
  validates :category_id, presence: true
end
