# encoding: utf-8
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