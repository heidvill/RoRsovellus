require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it "is saved with correct parameters" do
    recipe = Recipe.create name:"Ice cream", description:"Freeze", amount:4, duration:240

    expect(recipe).to be_valid
    expect(recipe.name).to eq("Ice cream")
    expect(Recipe.count).to eq 1
  end

  it "is not saved with empty name" do
    recipe = Recipe.create name:""

    expect(recipe).not_to be_valid
    expect(Recipe.count).to eq 0
  end

  it "prints duration with hours and minutes" do
    recipe = Recipe.create name:"Ice cream", description:"Freeze", amount:4, duration:245

    expect(recipe.duration_to_s).to eq ("4 hours 5 mins")
  end
end
