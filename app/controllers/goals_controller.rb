# This controller doesn't require CanCan permissions because it
# refers to the current users only. No way to hack unless you are
# able to login as the user.
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
    
    current_user.weight_change_rate = rate
    current_user.save
    
    redirect_to goals_path
  end
end