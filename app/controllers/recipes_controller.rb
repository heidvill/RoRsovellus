class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_units, only: [:new, :edit, :create]

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
    if request.xhr?
      @recipe = Recipe.new(recipe_params)
      hours = params.require(:data).permit(:time_h)[:time_h].to_i
      mins = params.require(:data).permit(:time_min)[:time_min].to_i
      @recipe.duration = hours * 60 + mins
      @recipe.user = current_user
      everything_valid = @recipe.valid?

      subsections = subsection_params[:subsections]
      subsections_h = {}
      (0..subsections.length-1).each do |i|
        subsection = subsections[i]
        @subsection = Subsection.new
        @subsection.title = subsection[:title]
        everything_valid = false if not @subsection.valid?
        ings = subsection[:ings]
        subsection_h = {}
        subsection_h["s"] = @subsection
        sub_ings_h = {}
        ings_h = {}
        (0..ings.length-1).each do |j|
          ing = ings[j]
          @subsection_ingredient = SubsectionIngredient.new
          @subsection_ingredient.amount = ing[:amount]
          @subsection_ingredient.unit = ing[:unit]
          @ingredient = Ingredient.new
          @ingredient.name = ing[:name]
          everything_valid = false if not @subsection_ingredient.valid?
          everything_valid = false if not @ingredient.valid?
          sub_ings_h[j] = @subsection_ingredient
          ings_h[j] = @ingredient
        end
        subsection_h["si"] = sub_ings_h
        subsection_h["ings"]= ings_h
        subsections_h[i] = subsection_h
      end

      if everything_valid
        @recipe.save
        (0..subsections_h.length-1).each do |i|
          @subsection = subsections_h[i]["s"]
          @subsection.recipe = @recipe
          @subsection.save
          sub_ings = subsections_h[i]["si"]
          ings = subsections_h[i]["ings"]
          (0..ings.length-1).each do |j|
            @subsection_ingredient = sub_ings[j]
            @ingredient = Ingredient.find_by_name(ings[j].name)
            if not @ingredient
              @ingredient = ings[j]
              @ingredient.save
            end
            @subsection_ingredient.subsection = @subsection
            @subsection_ingredient.ingredient = @ingredient
            @subsection_ingredient.save
          end
        end

        flash[:notice] = 'Recipe was successfully created!!!'
        flash.keep(:notice)

        render :json => {:location => url_for(recipes_path)}
      else
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
      format.html { redirect_to :back, notice: 'Recipe was successfully destroyed.' }
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
    params.require(:data).permit(:subsections => [:title, :ings => [:amount, :unit, :name]])
  end

  def subsection_ingredient_params
    params.require(:data).require(:subsections).require(:subsection_ingredients).permit(:amount, :unit)
  end

  def ingredient_params
    params.require(:data).require(:subsection).require(:subsection_ingredients).permit(:ingredient)
  end

  def set_units
    @units = ["dl", "l", "g", "kg", "tbsp", "tsp", "-", "pcs"]
  end
end
