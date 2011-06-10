# encoding: utf-8

# This controller doesn't require CanCan permissions because it
# refers to the current user only. No way to hack unless you are
# able to login as the user.
class SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    
  end
  
  def update
    current_user.update_attributes(params[:user])
    
    flash[:notice] = "Asetukset päivitetty onnistuneesti!"
    
    redirect_to settings_path
  end
end