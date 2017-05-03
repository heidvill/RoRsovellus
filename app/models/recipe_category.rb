class RecipeCategory < ApplicationRecord
  belongs_to :recipe, optional: true
  belongs_to :category, optional: true
end
