require 'rails_helper'

describe "Recipes page" do

  it "should not have any before been created" do
    visit recipes_path

    expect(page).to have_content 'Recipes'
    expect(page).not_to have_content 'Instruction'
  end

  describe "when recipes exists" do
    before :each do
      r1 = FactoryGirl.create(:recipe)
      r2 = FactoryGirl.create(:recipe2)

      visit recipes_path
    end

    it "has two recipes" do
      expect(page).to have_content "Cake"
      expect(page).to have_content "Rice"
    end

    it "allows user to navigate to page of a recipe" do
      click_link "Rice"

      expect(page).to have_content "Rice"
      expect(page).not_to have_content "Cake"
    end
  end
end

describe "Recipe" do

  before :each do
    WebMock.disable_net_connect!(allow_localhost:true)
    FactoryGirl.create :user
    sign_in(username: "jack", password: "Word1")
  end

  it "when filled with acceptable inputs, is added to the db", js:true do
    visit new_recipe_path

    fill_in('recipe_name', with: 'Salad')
    fill_in('recipe_amount', with: 4)
    fill_in('recipe_time_h', with: 0)
    fill_in('recipe_time_min', with: 15)

    fill_in('subsection_title1', with: "Salad")
    fill_in('subsection_ingredient_amount', with: 4)
    select('cups', from: 'subsection_ingredient[unit]')
    fill_in('ingredient_name', with: "lettuce")

    fill_in('recipe_description', with: "Wash and cut")

   # expect {
    #  click_button "Create Recipe"
    #}.to change{ Recipe.count }.from(0).to(1)

    click_button "Create Recipe"
    sleep 2
    expect(Recipe.count).to eq(1)
  end
end
