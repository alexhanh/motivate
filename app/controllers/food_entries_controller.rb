# coding: utf-8
class FoodEntriesController < ApplicationController
  before_filter :authenticate_user!

  # GET /posts
  # GET /posts.xml
  def index
    @consumable = find_consumable
  end
  
  def listtest    
    # if params[:date].nil?
    #   @time = Time.now
    # else
    #   begin
    #     @time = Time.strptime(params[:date], "%d%m%Y") + 12.hour # todo: why do we need to add 12 hours for this to work?
    #   rescue
    #     @time = Time.now
    #   end
    # end

    # todo: fix the hard coded time zone offset, ie. 3.hours.. Use time.zone
    # http://stackoverflow.com/questions/942747/set-current-time-zone-in-rails
    
    @food_entries = current_user.food_entries.on_date(@date + 3.hours).all#.paginate(:per_page => 5, :page => params[:page])
    @stats = NutritionStats.new
    @food_entries.each { |food_entry| @stats.add(food_entry) }
    
    render :locker_room
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
    
    if request.xhr?
      render 'new.js.erb'
    end
  end

  # GET /posts/1/edit
  def edit
    @food_entry = FoodEntry.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @consumable = find_consumable
    
    # alternative syntax:
    # @food_entry = FoodEntry.new(params[:food_entry])
    # @food_entry.consumable = @consumable
    @food_entry = @consumable.food_entries.build(params[:food_entry])
    @food_entry.user = current_user
    @food_entry.eaten_at = @date

    if @food_entry.valid? && @food_entry.update_data && @food_entry.save
      @consumable.add_eaten!
      flash[:notice] = 'Ruokalogi lisättiin onnistuneesti!'
      redirect_to index
    else
      if request.xhr?
        render 'new.js.erb'
      else
        render :action => 'new'
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @food_entry = FoodEntry.find(params[:id])
    if @food_entry.destroy
      flash[:notice] = "Ruokalogi poistettiin onnistuneesti"
      redirect_to eaten_path
    end
    #todo: check permission with cancan in ability.rb
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
