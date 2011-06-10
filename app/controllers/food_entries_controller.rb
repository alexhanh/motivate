# coding: utf-8
class FoodEntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @consumable = find_consumable
  end
  
  def show
  end

  def new
    @consumable = find_consumable
    @food_entry = FoodEntry.new
    
    if request.xhr?
      render 'new.js.erb'
    end
  end

  def edit
    @food_entry = FoodEntry.find(params[:id])
  end

  def create
    @consumable = find_consumable
    
    @food_entry = FoodEntry.new(params[:food_entry])
    @food_entry.consumable = @consumable

    @food_entry.user = current_user

    if @food_entry.save
      # @consumable.add_eaten!
      flash[:notice] = 'Ruokalogi lisättiin onnistuneesti!'
      redirect_to index
    else
      if request.xhr?
        render 'new.js.erb'
      else
        render :action => 'new'
      end
    end
  end

  def update
  end

  def destroy
    @food_entry = FoodEntry.find(params[:id])
    if @food_entry.destroy
      flash[:notice] = "Ruokalogi poistettiin onnistuneesti"
      redirect_to eaten_path
    end
    #todo: check permission with cancan in ability.rb
  end
end
