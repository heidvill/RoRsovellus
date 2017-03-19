require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it "has the name set correctly" do
    ingredient = Ingredient.create name:"flour"

    expect(ingredient).to be_valid
    expect(ingredient.name).to eq("flour")
  end

  it "is not saved with empty name" do
    ingredient = Ingredient.create name:""

    expect(ingredient).not_to be_valid
    expect(Ingredient.count).to eq 0
  end
end
