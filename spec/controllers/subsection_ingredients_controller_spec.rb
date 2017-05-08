require 'rails_helper'

RSpec.describe SubsectionIngredientsController, type: :controller do
  let!(:user) { FactoryGirl.create :user }
  let!(:recipe) { FactoryGirl.create :recipe }
  let!(:subsection) { FactoryGirl.create :subsection }
  let(:subsection_ingredient) { FactoryGirl.create :subsection_ingredient }
  let!(:ingredient) { FactoryGirl.create :ingredient }

  describe "DELETE #destroy" do

    before :each do
      allow(controller).to receive_messages(:current_user => user)
      recipe.subsections << subsection
      subsection.subsection_ingredients << subsection_ingredient
      ingredient.subsection_ingredients << subsection_ingredient
    end

    it "destroys the requested subsectionIngredient" do
      expect {
        delete :destroy, params: {id: subsection_ingredient.to_param}
      }.to change(SubsectionIngredient, :count).by(-1)
    end

    it "redirects to the recipe" do
      delete :destroy, params: {id: subsection_ingredient.to_param}
      expect(response).to redirect_to(edit_recipe_path(recipe.to_param))
    end

  end
end