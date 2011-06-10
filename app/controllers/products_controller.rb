# coding: utf-8
class ProductsController < ApplicationController
  # https://github.com/crowdint/rails3-jquery-autocomplete
  autocomplete :product, :brand, :scopes => [:uniquely_branded]
  
  before_filter :authenticate_user!, :except => [:index, :show]
  
  # respond_to :html
  
  def index
    # http://pivotallabs.com/users/grant/blog/articles/1566-pg-search-how-i-learned-to-stop-worrying-and-love-postgresql-full-text-search
    # TODO: - Should use a Finnish dictionary?
    #       - Add an index!!!
    if params[:search].blank?
      @products = Product.paginate(:per_page => 5, :page => params[:page])
    else
      @products = Product.search_by_name(params[:search]).paginate(:per_page => 5, :page => params[:page])
    end
  end

  def show
    @product = Product.find(params[:id], :include => [:user, :food_units])
  end

  def new
    @product = Product.new
    @product.food_units.build
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    if @product.save
      flash[:notice] = 'Tuote lisättiin onnistuneesti!'
    end
  end
  
  def update
    @product = Product.find(params[:id])
    flash[:notice] = 'Tuote päivitettiin onnistuneesti!' if @product.update_attributes(params[:product])
  end

  def destroy
    @product = Product.first(params[:id])
    @product.destroy
  end
  
  def fast_food
    @brands = %w[McDonald's Hesburger Picnic Subway Kotipizza]
    
    @products = Product.where(:brand => params[:brand]).paginate(:per_page => 10, :page => params[:page])
  end
end