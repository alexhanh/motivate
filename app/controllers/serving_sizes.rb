class ServingSizesController < ApplicationController
#  def create
#    @consumable = sdlhf.find(params[:consumable_id])
#    @serving_size = @consumable.serving_sizes.create!(params[:serving_size])
#  end
  def create
    @product = Product.find(params[:product_id])
    @product.serving_sizes << ServingSize.new(params[:serving_size])
    redirect_to @product, :notice => "Annoskoko lisattiin onnistuneesti!"
  end
end
