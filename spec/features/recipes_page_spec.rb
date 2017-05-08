require 'rails_helper'

include Helpers

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

describe "New recipe" do

  before :each do
    WebMock.disable_net_connect!(allow_localhost: true)
    FactoryGirl.create :user
    sign_in(username: "jack", password: "Word1")
  end

  it "when filled with acceptable inputs, is added to the db", js: true do
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

describe "Edit recipe page", js: true do
  let!(:recipe) { FactoryGirl.create :recipe }
  let!(:ingredient) { FactoryGirl.create :ingredient }
  let!(:subsection) { FactoryGirl.create :subsection }
  let!(:sub_ing) { FactoryGirl.create :subsection_ingredient }

  before :each do
    WebMock.disable_net_connect!(allow_localhost: true)
    FactoryGirl.create :user
    sign_in(username: "jack", password: "Word1")

    recipe.subsections << subsection
    subsection.subsection_ingredients << sub_ing
    ingredient.subsection_ingredients << sub_ing
  end

  context "with valid params" do
    it "only one ingredient added it updates correctly" do
      visit edit_recipe_path(1)
      click_button 'Ingredient'
      sleep 1
      fill_in('subsection_ingredient_amount', with: 2)
      select('dl', from: 'subsection_ingredient[unit]')
      fill_in('ingredient_name', with: 'water')

      click_button 'Update Recipe'
      sleep 1
      expect(recipe.subsection_ingredients.length).to eq(2)
    end

    it "new subsection and ingredients added it updates correctly" do
      visit edit_recipe_path(1)
      click_button 'Ingredient'
      click_button 'Section'
      sleep 1

      within("#ingredients1") do
        fill_in('subsection_ingredient_amount', with: 2)
        select('dl', from: 'subsection_ingredient[unit]')
        fill_in('ingredient_name', with: 'water')
      end

      fill_in('subsection_title2', with: 'filling')
      within("#ingredients2") do
        fill_in('subsection_ingredient_amount', with: 5)
        select('tbsp', from: 'subsection_ingredient[unit]')
        fill_in('ingredient_name', with: 'jam')
      end

      click_button 'Update Recipe'
      sleep 1
      expect(recipe.subsections.length).to eq(2)
      expect(recipe.subsection_ingredients.length).to eq(3)
    end
  end

  context "with invalid params" do
    it "shows edit form" do
      visit edit_recipe_path(1)
      click_button 'Ingredient'
      click_button 'Section'
      sleep 1

      click_button 'Update Recipe'
      expect(page).to have_content "Editing Recipe Cake"
    end
  end
end
