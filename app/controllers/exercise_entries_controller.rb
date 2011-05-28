class ExerciseEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @entry = ExerciseEntry.new
    @entry.userfy(current_user)
  end
  
  def create
    @entry = ExerciseEntry.new(params[:exercise_entry])
    @entry.user = current_user
    @entry.exercised_at = @date
    
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
    @entry.userfy(current_user)
  end
  
  def update
  end
  
  def delete
  end
end