# encoding: utf-8

# This controller doesn't require CanCan permissions because it
# refers to the current user only. No way to hack unless you are
# able to login as the user.
class StatusController < ApplicationController
  before_filter :authenticate_user!  
  
  def index
    today = Date.current
    if params[:date].blank?
      @date = today
    else
      @date = Date.parse(params[:date])
      @date = today if @date > today
    end

    @food_entries = current_user.food_entries.on_date(@date).select("SUM(energy) AS energy, SUM(protein) AS protein, SUM(fat) AS fat, SUM(carbs) AS carbs, COUNT(*) AS entries_count")[0]
    @stats = Food::Stats.new
    @stats.add(@food_entries) if @food_entries.entries_count.to_i > 0

    @exercise_entries = current_user.exercise_entries.on_date(@date).select("SUM(energy) AS energy_total")[0]
    @energy_burned = Quantity.new(@exercise_entries.energy_total.to_f, Units.kcal)

    @bmr = current_user.bmr(Time.now)
  end
end