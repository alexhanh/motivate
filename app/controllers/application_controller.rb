class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # after_filter :ensure_cancan_used
  # def ensure_cancan_used
  #   raise "CanCan not used in this controller action." unless instance_variable_defined?(:@current_ability)
  # end
  
  rescue_from CanCan::AccessDenied do |exception|
     flash[:error] = exception.message
     redirect_to root_url
   end
end
