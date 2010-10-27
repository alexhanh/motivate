class ProductsController < ApplicationController
  respond_to :html, :xml
  
  # GET /posts
  # GET /posts.xml
  def index
    @products = Product.all
    respond_with(@products)
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @product = Product.find(params[:id])
    respond_with(@product)
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @product = Product.new
#    @product.serving_sizes.build
#    @product.serving_sizes.first.nutrition_data.build

    5.times do
      @product.serving_sizes.build
      @product.serving_sizes.last.nutrition_data.build
    end
    
    puts @product.serving_sizes.size

#    @serving_size = "" #ServingSize.new
#    @nutrition_data = NutritionData.new
    respond_with(@product)
  end

  # GET /posts/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @serving_size = ServingSize.new(params[:serving_size])
    @serving_size.unit = Units::CUSTOM
    @nutrition_data = NutritionData.new(params[:nutrition_data])
    @serving_size.nutrition_data = @nutrition_data
    @product = Product.new(params[:product])
    @product.serving_sizes = [@serving_size]
    p @product
    p @product.serving_sizes
    flash[:notice] = 'Product was successfully created.' if @product.save
    p @product.valid?
    respond_with(@product)
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @product = Product.find(params[:id])
    p params
    flash[:notice] = 'Product was successfully updated.' if @product.update_attributes(params[:product])
    respond_with(@product)
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @product = Post.first(params[:id])
    @product.destroy
    respond_with(@product)
  end
end
