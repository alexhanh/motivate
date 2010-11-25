class FoodEntriesController < ApplicationController

  # GET /posts
  # GET /posts.xml
  def index
    @consumable = find_consumable
    p @consumable.class
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