class SubsectionsController < ApplicationController
  before_action :set_subsection, only: [:destroy]
  before_action :ensure_that_signed_in

  def destroy
    @recipe = @subsection.recipe
    @subsection.destroy
    respond_to do |format|
      format.html { redirect_to edit_recipe_path(@recipe.id), notice: 'Recipe was successfully updated.' }
      format.json { head :no_content }
    end
  end

  private
  def set_subsection
    @subsection = Subsection.find(params[:id])
  end
end