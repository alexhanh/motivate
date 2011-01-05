class RecipesController < ApplicationController
  respond_to :html, :xml

  # GET /posts
  # GET /posts.xml
  def index
    
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @recipe = Recipe.find(params[:id])
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    #@products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    
    # skip for AJAX search
    if !request.xhr?
      @recipe = Recipe.new
      #@recipe.serving_sizes << ServingSize.new
      @recipe.save({:validate => false})
    end
  end

  # GET /posts/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @recipe = Recipe.new(params[:recipe])
    p @recipe
    p @recipe.serving_sizes[0]
    flash[:notice] = 'Resepti luotiin onnistuneesti.' if @recipe.save!
    respond_with(@recipe)
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(params[:recipe])
      flash[:notice] = 'Resepti tallennettiin onnistuneesti!'
      redirect_to @recipe
    else
      p "EI ONNISTUNUT"
      render :action => 'edit'
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
  end

  def search_ingredients
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    
  end

  def find_ingredient
    #@recipe = Recipe.new
    #@ingredient = Ingredient.new
    @product = Product.find(params[:ingredient_id])
    #@ingredient.product = Product.find(params[:id])
    #@recipe.ingredients << @ingredient
    @recipe = Recipe.new
    @ingredient = Ingredient.new
  end
  
  def add_ingredient
    p "ADD"
  end
end