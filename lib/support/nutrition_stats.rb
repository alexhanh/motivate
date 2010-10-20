class NutritionStats
  attr_reader :protein, :energy, :fat, :carbs

  def initialize()
    @energy = 0.0
    @protein = 0.0
    @fat = 0.0
    @carbs = 0.0
  end

  def add(o)
    if o.kind_of? NutritionData
      add_nutrition(o)
    elsif o.respond_to? :nutrition_data
      add_nutrition(o.nutrition_data)
    else
      raise "Object must respond to .nutrition_data"
    end
  end
   
  def data
    NutritionData.new(:energy => @energy,
                      :protein => @protein,
                      :fat => @fat,
                      :carbs => @carbs)
  end
   
  private
  def add_nutrition(data)
    @energy += data.energy
    @protein += data.protein
    @fat += data.fat
    @carbs += data.carbs
  end
end
