class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_secure_password

  validates :username, uniqueness: true, length: {minimum: 3, maximum: 30}
  validates :password, length: {minimum: 4}
  validate :check_password

  def check_password
    errors.add(:password, "must have atleast one capital letter") if password and password == password.downcase
    errors.add(:password, "must have atleast one small letter") if password and password == password.upcase
    errors.add(:password, "must have atleast one number") if password and password.count("0-9") == 0
  end

  def to_s
    username
  end

  def last_recipe_time
    recipe = recipes.order(:created_at).last
    created = "No recipes" if recipe.nil?
    created = recipe.created_at.strftime("%B %d, %Y") if recipe
  end
end
