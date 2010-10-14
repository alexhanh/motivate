class NutritionStats
  def initialize()
    @energy = 0.0
    @protein = 0.0
    @fat = 0.0
    @carbs = 0.0
  end

  def add(data)
    @energy += data.energy
    @protein += data.protein
    @fat += data.fat
    @carbs += data.carbs
  end
  
  def data
    NutritionData.new(:energy => @energy,
                      :protein => @protein,
                      :fat => @fat,
                      :carbs => @carbs)
  end
end
