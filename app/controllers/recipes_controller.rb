class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create

    @recipe = Recipe.new(recipe_params)
    hours = params.require(:data).permit(:time_h)[:time_h].to_i
    mins = params.require(:data).permit(:time_min)[:time_min].to_i
    @recipe.duration = hours * 60 + mins

    @ingredient = Ingredient.new
    @ingredient.name = ingredient_params[:ingredient]

    @subsection_ingredient = SubsectionIngredient.new(subsection_ingredient_params)
    @subsection = Subsection.new(subsection_params)

    if request.xhr?
      if @recipe.save and @ingredient.save and @subsection.save and @subsection_ingredient
        @subsection.recipe = @recipe
        @subsection_ingredient.subsection = @subsection
        @subsection_ingredient.ingredient = @ingredient
        @subsection.save
        @subsection_ingredient.save

        flash[:notice] = 'Recipe was successfully created!!!'
        flash.keep(:notice)

        render :json => {:location => url_for(recipes_path)}
      else
        @recipe.valid?
        @subsection.valid?
        @subsection_ingredient.valid?
        @ingredient.valid?

        render :json => {:recipe_errors => @recipe.errors, :subsection_errors => @subsection.errors, :si_errors => @subsection_ingredient.errors, :ingredient_errors => @ingredient.errors}, :status => 422
      end
    else
      respond_to do |format|
        if @recipe.save and @ingredient.save and @subsection.save and @subsection_ingredient

          @subsection.recipe = @recipe
          @subsection_ingredient.subsection = @subsection
          @subsection_ingredient.ingredient = @ingredient
          @subsection.save
          @subsection_ingredient.save

          format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
          format.json { render :show, status: :created, location: @recipe }
          #format.js {render :json => {:location => url_for(recipes_path)}, notice: 'Tulee tänne.'}
        else
          format.html { render :new }
          format.json { render json: @recipe.errors, status: :unprocessable_entity }
          #format.js { render :json => {:errors => @recipe.errors}, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recipe_params
    params.require(:data).permit(:name, :description, :amount)
  end

  def subsection_params
    params.require(:data).require(:subsection).permit(:title)
  end

  def subsection_ingredient_params
    params.require(:data).require(:subsection).require(:subsection_ingredients).permit(:amount, :unit)
    #params.require(:data).require(:subsection).require(:subsection_ingredients).require(:amount)
    #params.require(:data).require(:subsection).require(:subsection_ingredients).require(:unit)
  end

  def ingredient_params
    params.require(:data).require(:subsection).require(:subsection_ingredients).permit(:ingredient)
  end
end
