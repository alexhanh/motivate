class ServingSizesController < ApplicationController
#  respond_to :html, :xml
#  def create
#    @consumable = sdlhf.find(params[:consumable_id])
#    @serving_size = @consumable.serving_sizes.create!(params[:serving_size])
#  end
  def create
    @product = Product.find(params[:product_id])
    @product.serving_sizes << ServingSize.new(params[:serving_size])
    p @product.serving_sizes.last
    @product.save!
    redirect_to @product, :notice => "Annoskoko lisattiin onnistuneesti!"
  end
  
  def new
    @product = Product.find(params[:product_id])
    @serving_size = ServingSize.new
  end
end
