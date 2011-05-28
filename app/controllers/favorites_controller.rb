# coding: utf-8
class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    #@favorites = Favorite.where(:user_id => current_user.id).all
    #@products = Product.where(:id$in => @favorites.map{|f| f.favorable_id})
  end
  
  def add
    @favorable = find_favorable
    @favorite = Favorite.new
    @favorite.favorable = @favorable
    @favorite.user = current_user
    if @favorite.save
      Jobs::Consumables.on_favorite(@favorable.id, @favorable.class.to_s)
      
      @favorable.add_favorite!(current_user)
      flash[:notice] = "Lisättiin suosikkeihin onnistuneesti!"
    else
      flash[:notice] = "Suosikkeihin lisääminen ei onnistunut. :("
    end
    
    redirect_to(:back) unless request.xhr?
  end
  
  def remove
    @favorable = find_favorable
    @favorite = current_user.favorite(@favorable)
    if @favorite && @favorite.destroy
      @favorable.remove_favorite!(current_user)
      flash[:notice] = "Poistettiin suosikeista onnistuneesti!"
    else
      flash[:notice] = "Suosikeista poistaminen ei onnistunut. :("
    end
    redirect_to(:back) unless request.xhr?
  end
  
  private
  def find_favorable
    params[:favorable_type].constantize.find(params[:favorable_id])
  end
end
