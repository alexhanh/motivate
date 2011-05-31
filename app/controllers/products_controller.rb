# coding: utf-8
class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  respond_to :html
  
  def index
    # http://pivotallabs.com/users/grant/blog/articles/1566-pg-search-how-i-learned-to-stop-worrying-and-love-postgresql-full-text-search
    # TODO: - Should use a Finnish dictionary?
    #       - Add an index!!!
    if params[:search].empty?
      @products = Product.paginate(:per_page => 5, :page => params[:page])
    else
      @products = Product.search_by_name(params[:search]).paginate(:per_page => 5, :page => params[:page])
    end
    respond_with(@products)
  end

  def show
    @product = Product.find(params[:id], :include => [:user, :food_units])
    respond_with(@product)
  end

  def new
    @product = Product.new
    @product.food_units.build
    respond_with(@product)
  end

  def edit
    @product = Product.find(params[:id])
    respond_with(@product)
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    if @product.save
      flash[:notice] = 'Tuote lisättiin onnistuneesti!'
    end
    respond_with(@product)
  end
  
  def update
    @product = Product.find(params[:id])
    flash[:notice] = 'Product was successfully updated.' if @product.update_attributes(params[:product])
    respond_with(@product)
  end

  def destroy
    @product = Post.first(params[:id])
    @product.destroy
    respond_with(@product)
  end
end