class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /ingredients
  # GET /ingredients.json
  def index
    @ingredients_with_no_sub_ings = Ingredient.includes(:subsection_ingredients).where(:subsection_ingredients => {:ingredient_id => nil})
    @ingredients_with_no_sub_ings.each { |i| i.delete }

    @ingredients = Ingredient.all
    @ingredients = @ingredients.sort_by { |i| i.name.downcase }
  end

  # GET /ingredients/1
  # GET /ingredients/1.json
  def show
  end

  # GET /ingredients/1/edit
  def edit
  end

  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to ingredients_url, notice: 'Ingredient was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingredient }
      else
        format.html { render :edit }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingredient_params
    params.require(:ingredient).permit(:name)
  end
end
