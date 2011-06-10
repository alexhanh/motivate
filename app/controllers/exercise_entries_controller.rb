# encoding: utf-8
class ExerciseEntriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @entries = ExerciseEntry.where(:user_id => current_user.id).includes(:exercise).order("exercised_at DESC").paginate(:per_page => 5, :page => params[:page])
  end
  
  def new
  end
  
  def create
    @exercise_entry.user = current_user
    
    if @exercise_entry.save
      Jobs::ExerciseEntries.on_create(@exercise_entry.id)
      redirect_to exercise_entries_url, :notice => "Liikunta lisätty onnistuneesti!"
    else
      render :new
    end
  end
  
  def edit
    @exercise_entry.energy = nil if @exercise_entry.estimated
  end
  
  def update
    estimated = {}
    estimated = { :estimated => false } unless params[:exercise_entry][:energy].blank?
    
    if @exercise_entry.update_attributes(params[:exercise_entry].merge(estimated))
      redirect_to exercise_entries_url, :notice => "Liikuntalogia muokattu onnistuneesti!"
    else
      render :action => :edit
    end
  end
  
  def destroy
    @exercise_entry.destroy
    redirect_to :action => :index
  end
end