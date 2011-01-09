class FoodEntriesController < ApplicationController

  # GET /posts
  # GET /posts.xml
  def index
    @consumable = find_consumable
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @consumable = find_consumable
    @food_entry = FoodEntry.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.xml
  def create
    @consumable = find_consumable
    
    # alternative syntax:
    # @food_entry = FoodEntry.new(params[:food_entry])
    # @food_entry.consumable = @consumable
    @food_entry = @consumable.food_entries.build(params[:food_entry])

    if @food_entry.valid? && @food_entry.update_data && @food_entry.save
      flash[:notice] = 'Food entry was successfully created.'
      redirect_to index
    else
      render :action => 'new'
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
  end
  
  private
  def find_consumable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.pluralize.classify.constantize.find(value) 
        #$1.titleize.constantize.find(value)
      end
    end
    nil
  end
end