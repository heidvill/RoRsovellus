require 'rails_helper'

RSpec.describe SubsectionsController, type: :controller do
  let!(:user) { FactoryGirl.create :user }
  let!(:recipe) { FactoryGirl.create :recipe }
  let!(:subsection) { FactoryGirl.create :subsection }

  describe "DELETE #destroy" do

    before :each do
      allow(controller).to receive_messages(:current_user => user)
      recipe.subsections << subsection
    end

    it "destroys the requested subsection" do
      expect {
        delete :destroy, params: {id: subsection.to_param}
      }.to change(Subsection, :count).by(-1)
    end

    it "redirects to the recipe" do
      delete :destroy, params: {id: subsection.to_param}
      expect(response).to redirect_to(edit_recipe_path(recipe.to_param))
    end

  end
end