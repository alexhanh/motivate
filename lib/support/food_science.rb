module FoodScience
  def self.energy_to_fat(energy)
    # There are 3500 calories in 1 lb (0.45 kg) of body fat.
    (energy.to(:kcal).value / 3500 * 0.45).kg
  end
  
  def self.fat_to_energy(weight)
    (weight.to(:kg).value / 0.45 * 3500).kcal
  end
  
  # https://sites.google.com/site/compendiumofphysicalactivities/corrected-mets
  def self.personalized_met(met, weight, height, age, sex)
    rmr_kcal = harris_benedict(weight, height, age, sex).value
    weight_kg = weight.to(:kg).value
    met * 3.5/(rmr_kcal/1440.0/5.0/weight_kg*1000.0)
  end
  
  def self.harris_benedict(weight, height, age, sex)
    height_cm = height.to(:cm).value
    weight_kg = weight.to(:kg).value
    
    if sex == :male || sex.is_a?(TrueClass)
      (66.5 + 5.003*height_cm + 13.75*weight_kg - 6.775*age).kcal
    else
      (655.1 + 1.850*height_cm + 9.563*weight_kg - 4.676*age).kcal
    end
  end
end