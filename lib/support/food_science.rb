module FoodScience
  def self.energy_to_fat(energy_quantity, output_weight_unit)
    # There are 3500 calories in 1 lb (0.45 kg) of body fat.
    Quantity.new(energy_quantity.convert(Units.kcal).value / 3500 * 0.45, Units.kg).convert(output_weight_unit)
  end
  
  def self.fat_to_energy(weight_quantity, output_energy_unit=Units.kcal)
    Quantity.new(weight_quantity.convert(Units.kg).value / 0.45 * 3500, Units.kcal).convert(output_energy_unit)
  end
end