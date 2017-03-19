require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it "has the name set correctly" do
    ingredient = Ingredient.new name:"flour"

    expect(ingredient.name).to eq("flour")
  end
end
