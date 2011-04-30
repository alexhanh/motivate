class ExerciseEntriesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @entry = ExerciseEntry.new
  end
  
  def create
    @entry = ExerciseEntry.new(params[:exercise_entry])
    @entry.user = current_user
    @entry.exercised_at = @date
    
    if @entry.save
      flash[:notice] = "Entry succesfully saved."
      redirect_to :root
      return
    end
    
    render :new
  end
  
  def edit
  end
  
  def update
  end
  
  def delete
  end
end