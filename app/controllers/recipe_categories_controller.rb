class RecipeCategoriesController < ApplicationController
  before_action :set_recipe_category, only: [:destroy]

  def new
    @recipe_category = RecipeCategory.new
    @categories = Category.all
    @recipes = Recipe.all
  end

  def create
    @recipe_category = RecipeCategory.new(recipe_category_params)

    respond_to do |format|
      if @recipe_category.save
        format.html { redirect_to @recipe_category.recipe, notice: 'Category was successfully added.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @recipe = @recipe_category.recipe
    @recipe_category.destroy
    respond_to do |format|
      format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recipe_category
    @recipe_category = RecipeCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recipe_category_params
    params.require(:recipe_category).permit(:recipe_id, :category_id)
  end
end