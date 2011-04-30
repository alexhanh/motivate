class TrackerEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  # authorize using can can
  
  def index
    @trackers = get_trackers
    
    @tracker = nil
    if params[:tracker_id]
      @tracker = Tracker.find(params[:tracker_id])
    else
      @tracker ||= @trackers.first
    end
    
    @entries = TrackerEntry.where(:user_id => current_user.id, :tracker_id => @tracker.id).all#.fields(:logged_on, :value)
    @data = @entries.map { |e| [e.logged_on.to_time.to_i*1000, e.quantity.convert(@tracker.base_unit).value] }.inspect
  end
  
  def new
    @trackers = get_trackers
  end
  
  def create
    @entry = TrackerEntry.new(params[:tracker_entry])
    @entry.user = current_user
    @entry.logged_on = @date
    
    if !@entry.save
      render "change_tracker.js.erb"
    end
  end
  
  # extra important to check permission with cancan
  def destroy
    @entry = TrackerEntry.find(params[:id])
    @entry.destroy
    redirect_to :action => 'index', :tracker_id => params[:tracker_id]
  end
  
  def change_tracker
    @entry = TrackerEntry.new(params[:tracker_entry])
    if !@entry.tracker.valid?
      render :nothing => true
      # todo: handle better
    end
    @entry.unit = @entry.tracker.custom_unit if @entry.tracker.custom?
  end
  
  def get_trackers
    Tracker.where("private = ? OR user_id = ?", false, current_user.id)
  end
end