require 'rails_helper'

RSpec.describe SubsectionIngredient, type: :model do
  it "is saved with correct amount" do
    si = SubsectionIngredient.create amount:5

    expect(si).to be_valid
    expect(SubsectionIngredient.count).to eq 1
  end

  it "correct to_s" do
    i = Ingredient.create name:"flour"
    si = SubsectionIngredient.create amount:5, unit:"dl", ingredient_id:i.id

    expect(si.to_s).to eq("5 dl flour")
  end
end
