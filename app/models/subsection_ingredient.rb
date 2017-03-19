class SubsectionIngredient < ApplicationRecord
  belongs_to :subsection, optional: true
  belongs_to :ingredient, optional: true

  validates :amount, presence: true

  def to_s
    "#{amount} #{unit} #{ingredient.name}"
  end

end
