# encoding: utf-8
class TrackerEntriesController < ApplicationController
  before_filter :authenticate_user!  
  load_and_authorize_resource
  
  def index
    @trackers = get_trackers
    
    @tracker = nil
    unless params[:tracker_id].blank?
      tracker_id = params[:tracker_id].to_i
      for tracker in @trackers do
        if tracker.id == tracker_id
          @tracker = tracker
          break
        end
      end
    end
    
    @tracker ||= @trackers.first
    @entries = TrackerEntry.where(:user_id => current_user.id, :tracker_id => @tracker.id).order("logged_on DESC").paginate(:per_page => 5, :page => params[:page])

    @all_entries = TrackerEntry.where(:user_id => current_user.id, :tracker_id => @tracker.id).order("logged_on DESC").limit(1000)
    # TODO: Check that the date is converted properly and Time.zone is respected
    @data = @all_entries.map { |e| [e.logged_on.to_date.to_datetime.to_i*1000, e.quantity.to(@tracker.base_unit).value] }.inspect
  end
  
  def new
    @trackers = get_trackers
    @tracker_entry.tracker = @trackers.first
  end
  
  def create
    @tracker_entry.unit = @tracker_entry.tracker.base_unit.id
    @tracker_entry.user = current_user
    
    if @tracker_entry.save
      Jobs::TrackerEntries.on_create(@tracker_entry.id)
      redirect_to tracker_entries_url(:tracker_id => @tracker_entry.tracker_id), :notice => "Mittaus lisätty onnistuneesti!"
    else
      @trackers = get_trackers
      render :action => :new
    end
  end
  
  def edit
    @trackers = get_trackers
  end

  def update
    @tracker_entry.unit = @tracker_entry.tracker.base_unit.id
    
    if @tracker_entry.update_attributes(params[:tracker_entry])
      redirect_to tracker_entries_url(:tracker_id => @tracker_entry.tracker_id), :notice => "Mittaustulosta muokattu onnistuneesti!"
    else
      @trackers = get_trackers
      render :action => :edit
    end
  end
  
  def destroy
    @tracker_entry.destroy
    redirect_to :action => :index, :tracker_id => params[:tracker_id]
  end
  
  protected
  def get_trackers
    Tracker.where("private = ? OR user_id = ?", false, current_user.id)
  end
end