class SubsectionIngredient < ApplicationRecord
  belongs_to :subsection, optional: true
  belongs_to :ingredient, optional: true
  #accepts_nested_attributes_for :ingredient

  validates :amount, presence: true

  def to_s
    "#{amount} #{unit} #{ingredient.name}"
  end

end
