class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # todo: probably should remove me after done hacking locales
  # see better ways to set this here http://guides.rubyonrails.org/i18n.html
  before_filter :set_locale
  before_filter :set_date
  
  # after_filter :ensure_cancan_used
  # def ensure_cancan_used
  #   raise "CanCan not used in this controller action." unless instance_variable_defined?(:@current_ability)
  # end
  
  rescue_from CanCan::AccessDenied do |exception|
     flash[:error] = exception.message
     redirect_to root_url
  end
   
  def set_locale
   # if params[:locale] is nil then I18n.default_locale will be used
   I18n.locale = params[:locale]
  end
  
  def set_date
    # todo: take current locale and user time zone into consideration
    # todo: set time.now if not parseable
    # todo: set time.now if date passed is in the future
    if params[:date]
      @date = Time.strptime(params[:date], "%d%m%Y")
      @date = Time.now if @date > Time.now
      session[:date] = params[:date]
    else
      @date = Time.now
      session[:date] ||= @date.strftime("%d%m%Y")
      @date = Time.strptime(session[:date], "%d%m%Y")
    end
  end
end
