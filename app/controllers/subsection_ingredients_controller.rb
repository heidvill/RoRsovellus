class SubsectionIngredientsController < ApplicationController
  before_action :set_subsection_ingredient, only: [:destroy]
  before_action :ensure_that_signed_in

  def destroy
    @recipe = @subsection_ingredient.subsection.recipe
    @subsection_ingredient.destroy
    respond_to do |format|
      format.html { redirect_to edit_recipe_path(@recipe.id), notice: 'Recipe was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
  def set_subsection_ingredient
    @subsection_ingredient = SubsectionIngredient.find(params[:id])
  end
end