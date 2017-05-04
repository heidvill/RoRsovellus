require 'rails_helper'

RSpec.describe RecipeCategoriesController, type: :controller do
  before (:each) do
    FactoryGirl.create(:recipe)
  end

  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {recipe_id:1, category_id:1}
  }

  let(:invalid_attributes) {
    {recipe_id:nil, category_id:nil}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CategoriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #new" do
    it "assigns a new category as @category" do
      get :new, params: {recipe_category: valid_attributes}, session: valid_session
      expect(assigns(:recipe_category)).to be_a_new(RecipeCategory)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, params: {recipe_category: valid_attributes}, session: valid_session
        }.to change(RecipeCategory, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, params: {recipe_category: valid_attributes}, session: valid_session
        expect(assigns(:recipe_category)).to be_a(RecipeCategory)
        expect(assigns(:recipe_category)).to be_persisted
      end

      it "redirects to recipe" do
        post :create, params: {recipe_category: valid_attributes}, session: valid_session
        expect(response).to redirect_to(recipe_path(1))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        post :create, params: {recipe_category: invalid_attributes}, session: valid_session
        expect(assigns(:recipe_category)).to be_a_new(RecipeCategory)
      end

      it "re-renders the 'new' template" do
        post :create, params: {recipe_category: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      recipe_category = RecipeCategory.create! valid_attributes
      expect {
        delete :destroy, params: {id: recipe_category.to_param}, session: valid_session
      }.to change(RecipeCategory, :count).by(-1)
    end

    it "redirects to the recipe" do
      recipe_category = RecipeCategory.create! valid_attributes
      delete :destroy, params: {id: recipe_category.to_param}, session: valid_session
      expect(response).to redirect_to(recipe_path(1))
    end
  end

end
