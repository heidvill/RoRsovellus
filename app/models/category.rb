class Category < ApplicationRecord
  validates :name, length: {minimum: 3, maximum: 30}
end
