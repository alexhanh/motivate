# coding: utf-8
class ServingSizesController < ApplicationController
  before_filter :authenticate_user!
#  respond_to :html, :xml
#  def create
#    @consumable = sdlhf.find(params[:consumable_id])
#    @serving_size = @consumable.serving_sizes.create!(params[:serving_size])
#  end
  def create
    @product = Product.find(params[:product_id])
    @serving_size = ServingSize.new(params[:serving_size])
    @product.serving_sizes << @serving_size

    if @serving_size.valid? && @product.save
      redirect_to @product, :notice => "Annoskoko lisättiin onnistuneesti!"
    else
      @product.serving_sizes.delete_at(-1)
      render :action => 'new'
    end
  end
  
  def new
    @product = Product.find(params[:product_id])
    @serving_size = ServingSize.new
  end
end
