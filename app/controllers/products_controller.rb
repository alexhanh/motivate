class ProductsController < ApplicationController
  respond_to :html, :xml
  
  # GET /posts
  # GET /posts.xml
  def index
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
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

    #5.times do
      @product.serving_sizes.build
      @product.serving_sizes.first.nutrition_data.build
    #end

    respond_with(@product)
  end

  # GET /posts/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @product = Product.new(params[:product])
    flash[:notice] = 'Product was successfully created.' if @product.save
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
  
  def test
    @product = Product.find(params[:id])
    respond_with(@product)
  end
end
