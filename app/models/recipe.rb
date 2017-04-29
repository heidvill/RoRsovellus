class Recipe < ApplicationRecord
  belongs_to :user, optional: true
  has_many :subsections, dependent: :destroy
  has_many :subsection_ingredients, through: :subsections, dependent: :destroy
  has_many :ingredients, through: :subsection_ingredients

  validates :name, length: {minimum: 3, maximum: 30}
  validates :description, length: {minimum: 3, maximum: 1500}
  validates :amount, numericality: {greater_than_or_equal_to: 1, only_integer: true}
  validates :duration, numericality: {greater_than_or_equal_to: 1}

  def duration_to_s
    hh, mm = duration.divmod(60)
    "#{hh} hours #{mm} mins"
  end

end
