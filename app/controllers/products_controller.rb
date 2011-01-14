class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
#  load_and_authorize_resource
  
  respond_to :html, :xml
  
  # GET /posts
  # GET /posts.xml
  def index
    Resque.enqueue(Jobs::TestJob, "Lol")
    @products = Product.search(params[:search]).paginate(:per_page => 5, :page => params[:page])    
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

    respond_with @product
  end

  # GET /posts/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @product = Product.new(params[:product])

    @product.user = current_user

    if @product.save
      flash[:notice] = 'Product was successfully created.'
      redirect_to @product
    else
      render :action => 'new'
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @product = Product.find(params[:id])
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
