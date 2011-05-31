class ExerciseEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @entry = ExerciseEntry.new
  end
  
  def create
    @entry = ExerciseEntry.new(params[:exercise_entry])
    @entry.user = current_user
    
    if @entry.save
      Jobs::ExerciseEntries.on_create(@entry.id)
      flash[:notice] = "Entry succesfully saved."
      redirect_to :root
      return
    end
    
    render :new
  end
  
  def edit
    @entry = ExerciseEntry.find(params[:id])
  end
  
  def update
  end
  
  def delete
  end
end