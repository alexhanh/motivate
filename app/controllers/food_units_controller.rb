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
  
  def update
    @food_unit = FoodUnit.includes(:consumable).find(params[:id])
    
    if @food_unit.update_attributes(params[:food_unit])
      redirect_to polymorphic_url(@food_unit.consumable), :notice => "Yksikköä muokattu onnistuneesti!"
    else
      @product = Product.find(params[:product_id])
      render :action => :edit
    end
  end
  
  def destroy
    @food_unit = FoodUnit.includes(:consumable).find(params[:id])
    consumable = @food_unit.consumable
    if @food_unit.destroy
      redirect_to polymorphic_url(consumable), :notice => "Yksikkö poistettu onnistuneesti!"
    end
  end
  
  def relation
    @product = Product.find(params[:product_id])
    @food_unit = FoodUnit.new(:consumable => @product, :value => 1.0, :unit => params[:runit], :parent_value => params[:parent_value], :parent_unit => params[:parent_unit])
    
    if @food_unit.save
      redirect_to polymorphic_url(@food_unit.consumable), :notice => "Yksikkö lisätty onnistuneesti!"
    else
      @render_new = false
      render :action => :new
    end
  end
end
