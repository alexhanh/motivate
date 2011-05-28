class GoalsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  end
  
  def update
    weeks = params[:weeks].to_f
    
    if weeks > 0
      rate = params[:weight].to_f * params[:goal].to_i / weeks 
    else
      rate = 0
    end
    
    current_user.weight_change_rate = Quantity.new(rate, current_user.weight_unit)
    current_user.save
    
    redirect_to goals_path
  end
end