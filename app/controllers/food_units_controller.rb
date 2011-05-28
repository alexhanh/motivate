# coding: utf-8
class FoodUnitsController < ApplicationController
  before_filter :authenticate_user!
#  respond_to :html, :xml
#  def create
#    @consumable = sdlhf.find(params[:consumable_id])
#    @serving_size = @consumable.serving_sizes.create!(params[:serving_size])
#  end
  def new
    @product = Product.find(params[:product_id])
    @food_unit = FoodUnit.new
  end

  def create
    @product = Product.find(params[:product_id], :include => [:food_units])
    @food_unit = FoodUnit.new(params[:food_unit])
    @food_unit.value = 1.0
    @food_unit.consumable = @product
    # TODO: check for parent unit's existence
    # TODO: check if product already contains the unit

    if @food_unit.save
      redirect_to @product, :notice => "Annoskoko lisättiin onnistuneesti!"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @food_unit = FoodUnit.find(params[:id])
    @product = Product.find(params[:product_id])
  end
end
