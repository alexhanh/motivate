class RecipesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  respond_to :html, :xml

  # GET /posts
  # GET /posts.xml
  def index
    @recipes = Recipe.paginate(:per_page => 5, :page => params[:page])
    respond_with(@recipes)
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @recipe = Recipe.find(params[:id])
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    
    # skip for AJAX search
    if !request.xhr?
      @recipe = Recipe.new
      @recipe.serving_sizes << ServingSize.new
      #@recipe.save({:validate => false})
    end
  end

  # GET /posts/1/edit
  def edit
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    @recipe = Recipe.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    
    @recipe = Recipe.new(params[:recipe])
    @recipe.user = current_user
    if @recipe.save
      flash[:notice] = 'Resepti luotiin onnistuneesti!'
      redirect_to @recipe
    else
      render :action => 'new'
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @recipe = Recipe.find(params[:id])
    @recipe = Recipe.create(params[:id]) if @recipe.nil?
    if @recipe.update_attributes(params[:recipe])
      flash[:notice] = 'Resepti tallennettiin onnistuneesti!'
      redirect_to @recipe
    else
      render :action => 'edit'
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
  end

  def find_ingredient
    @product = Product.find(params[:ingredient_id])
    @recipe = Recipe.new
    @recipe.ingredients.build(:product => @product)
    render 'find_ingredient.js.erb'
  end
  
  # POST /recipes/add_ingredient/
  def add_ingredient
    @recipe = Recipe.new
    @recipe.ingredients.build(params[:ingredient]) 
    #@ingredient = Ingredient.new(params[:ingredient])
  end
  
  # DELETE /recipes/:id/remove_ingredient/:ingredient_id
  def remove_ingredient
    @recipe = Recipe.find(params[:id])
    unless @recipe.nil?
      oid = BSON::ObjectId.from_string(params[:ingredient_id])
      @recipe.ingredients.delete_if { |ingredient| ingredient.id == oid }
      @recipe.save
    end
    
  end
end
