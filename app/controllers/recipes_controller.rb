class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_units, only: [:new, :edit, :create]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
    order = params[:order] || 'name'
    @recipes = case order
                 when 'name' then
                   Recipe.order(:name)
                 when 'added' then
                   Recipe.order(created_at: :desc)
               end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    session[:recipe_id] = @recipe.id
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
    @recipe.user = current_user

    if request.xhr?
      everything_valid = @recipe.valid?

      subsections = subsection_params[:subsections]

      returned = create_subsections(subsections, everything_valid)
      subsections_h = returned[0]
      everything_valid = returned[1]

      if everything_valid
        @recipe.save
        save_subs_n_ings(subsections_h)

        flash[:notice] = 'Recipe was successfully created!'
        flash.keep(:notice)

        render :json => {:location => url_for(recipe_path(@recipe.id))}
      else
        render :json => {:recipe_errors => [@recipe.errors], :subsection_errors => returned[2], :si_errors => returned[3], :ingredient_errors => returned[4]}, :status => 422
      end
    else
      respond_to do |format|
        if @recipe.save
          format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
          format.json { render :show, status: :created, location: @recipe }
        else
          format.html { render :new }
          format.json { render json: @recipe.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    if request.xhr?
      hours = params.require(:data).permit(:time_h)[:time_h].to_i
      mins = params.require(:data).permit(:time_min)[:time_min].to_i
      @recipe.duration = hours * 60 + mins
      @recipe.description = params.require(:data).permit(:description)[:description]
      @recipe.amount = params.require(:data).permit(:amount)[:amount]
      everything_valid = @recipe.valid?

      subsections = subsection_params[:subsections]

      returned = update_subsections(subsections, everything_valid)
      subsections_h = returned[0]
      everything_valid = returned[1]

      if everything_valid
        @recipe.save
        save_subs_n_ings(subsections_h) unless subsections_h.empty?

        flash[:notice] = 'Recipe was successfully updated!'
        flash.keep(:notice)

        render :json => {:location => url_for(recipe_path(@recipe.id))}
      else
        subsection_errors = returned[2]
        sub_ing_errors = returned[3]
        ing_errors = returned[4]

        render :json => {:recipe_errors => [@recipe.errors], :subsection_errors => subsection_errors, :si_errors => sub_ing_errors, :ingredient_errors => ing_errors}, :status => 422
      end
    else
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
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Recipe was successfully destroyed.' }
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
    @units = ["dl", "l", "g", "kg", "tbsp", "tsp", "-", "pcs", "cups"]
  end

  def create_subsections(subsections, everything_valid)
    subsections_h = {}
    subsection_errors = []
    sub_ing_errors = []
    ing_errors = []

    (0..subsections.length-1).each do |i|
      subsection = subsections[i]
      @subsection = Subsection.new
      @subsection.title = subsection[:title]
      everything_valid = false unless @subsection.valid?
      subsection_errors.push @subsection.errors unless @subsection.valid?
      ings = subsection[:ings]
      subsection_h = {}
      subsection_h["s"] = @subsection

      #sub_ings_h, ings_h, everything_valid = create_sub_ings_n_ings(ings, everything_valid)

      returned = create_sub_ings_n_ings(ings, everything_valid)
      sub_ings_h = returned[0]
      ings_h = returned[1]
      everything_valid = returned[2]
      sub_ing_errors.push(*returned[3])
      ing_errors.push(*returned[4])

      subsection_h["si"] = sub_ings_h
      subsection_h["ings"]= ings_h
      subsections_h[i] = subsection_h
    end

    [subsections_h, everything_valid, subsection_errors, sub_ing_errors, ing_errors]
  end

  def create_sub_ings_n_ings(ings, everything_valid)
    sub_ings_h = {}
    ings_h = {}
    sub_ing_error = []
    ing_error = []

    (0..ings.length-1).each do |j|
      ing = ings[j]
      @subsection_ingredient = SubsectionIngredient.new
      @subsection_ingredient.amount = ing[:amount]
      @subsection_ingredient.unit = ing[:unit]
      @ingredient = Ingredient.new
      @ingredient.name = ing[:name]

      everything_valid = false unless @subsection_ingredient.valid?
      everything_valid = false unless @ingredient.valid?
      sub_ing_error.push(@subsection_ingredient.errors) unless @subsection_ingredient.valid?
      ing_error.push(@ingredient.errors) unless @ingredient.valid?

      sub_ings_h[j] = @subsection_ingredient
      ings_h[j] = @ingredient
    end

    [sub_ings_h, ings_h, everything_valid, sub_ing_error, ing_error]
  end

  def save_subs_n_ings(subsections_h)
    (0..subsections_h.length-1).each do |i|
      @new_subsection = subsections_h[i]["s"]
      @subsection = Subsection.where(recipe_id: @recipe.id, title: @new_subsection.title).first
      if @subsection.nil?
        @subsection = @new_subsection
        @subsection.recipe = @recipe
        @subsection.save
      end
      sub_ings = subsections_h[i]["si"]
      ings = subsections_h[i]["ings"]
      unless ings.nil?
        (0..ings.length-1).each do |j|
          @subsection_ingredient = sub_ings[j]
          @ingredient = Ingredient.find_by_name(ings[j].name)
          unless @ingredient
            @ingredient = ings[j]
            @ingredient.save
          end
          @subsection_ingredient.subsection = @subsection
          @subsection_ingredient.ingredient = @ingredient
          @subsection_ingredient.save
        end
      end
    end
  end

  def update_subsections(subsections, everything_valid)
    subsections_h = {}
    subsection_errors = []
    sub_ing_errors = []
    ing_errors = []

    (0..subsections.length-1).each do |i|
      subsection = subsections[i]
      @subsection = Subsection.new
      @subsection.title = subsection[:title]

      everything_valid = false unless @subsection.valid?
      subsection_errors.push(@subsection.errors) unless @subsection.valid?

      subsection_h = {}
      subsection_h["s"] = @subsection

      ings = subsection[:ings]
      were_there_any_ings = false

      unless ings.nil?
        returned = create_sub_ings_n_ings(ings, everything_valid)

        sub_ings_h = returned[0]
        ings_h = returned[1]
        everything_valid = returned[2]
        sub_ing_errors.push(*returned[3])
        ing_errors.push(*returned[4])

        subsection_h["si"] = sub_ings_h
        subsection_h["ings"]= ings_h
        were_there_any_ings = true;
      end
      subsections_h[i] = subsection_h if were_there_any_ings
    end

    [subsections_h, everything_valid, subsection_errors, sub_ing_errors, ing_errors]
  end
end
