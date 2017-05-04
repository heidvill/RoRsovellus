require 'rails_helper'

RSpec.describe RecipeCategory, type: :model do
  it "connects right recipe and category" do
    r = FactoryGirl.create(:recipe)
    c = Category.create name: "lunch"

    rc = RecipeCategory.create recipe_id: r.id, category_id: c.id

    expect(rc.category).to eq(c)
    expect(rc.recipe).to eq(r)
  end
end
