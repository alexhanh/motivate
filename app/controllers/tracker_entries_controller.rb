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

    # TODO: Check that the date is converted properly and Time.zone is respected
    @data = @entries.map { |e| [e.logged_on.to_date.to_datetime.to_i*1000, e.quantity.convert(@tracker.base_unit).value] }.inspect
  end
  
  def new
    @trackers = get_trackers
  end
  
  def create
    @entry = TrackerEntry.new(params[:tracker_entry])
    @entry.user = current_user
    
    if !@entry.save
      render "change_tracker.js.erb"
    else
      Jobs::TrackerEntries.on_create(@entry.id)
    end
  end
  
  # extra important to check permission with cancan
  def edit
    @entry = TrackerEntry.find(params[:id])
    @show_submit = true
    @remote = false
  end

  # extra important to check permission with cancan  
  def update
    @entry = TrackerEntry.find(params[:id])
    if @entry.update_attributes(params[:tracker_entry])
      redirect_to tracker_entries_path, :notice => "Mittaustulosta muokattu onnistuneesti!"
    else
      render :action => :edit
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