class SubsectionIngredient < ApplicationRecord
  belongs_to :subsection, optional: true
  belongs_to :ingredient, optional: true

  validates :amount, presence: true, numericality: {greater_than: 0, less_than: 5000}

  def to_s
    "#{amount_to_s} #{unit} #{ingredient.name}"
  end

  def amount_to_s
    s = amount
    s = amount.to_i if amount % 1 == 0
    s
  end
end
