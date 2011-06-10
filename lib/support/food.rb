module Food
  # Assumptions about units in which the components are in:
  # Energy (kcal)
  # Carbs (g)
  # Protein (g)
  # Fat (g)
  module Components
    attr_reader :energy, :protein, :carbs, :fat
  end
  
  class Data
    include Components
 
    def initialize(energy, protein, carbs, fat)
      @energy, @protein, @carbs, @fat = energy||0.0, protein||0.0, carbs||0.0, fat||0.0
    end
  
    def scale(f)
      Food::Data.new(
        energy ? f*energy : nil,
        protein ? f*protein : nil,
        carbs ? f*carbs : nil,
        fat ? f*fat : nil
        )
    end
  end

  class Stats
    include Components
    
    # All densities are in kcal/g
    PROTEIN_DENSITY = 4.015
    CARBS_DENSITY = 4.015
    FAT_DENSITY = 9.028
  
    def initialize()
      @energy = 0.0
      @protein = 0.0
      @carbs = 0.0
      @fat = 0.0
    end
  
    def add(o)
      @energy += o.energy || 0
      @protein += o.protein || 0
      @carbs += o.carbs || 0
      @fat += o.fat || 0
    end
  
    # The difference between energy and energy_pcf is that
    # energy_pcf is calculated using the amounts of protein,
    # fat and carbs and their corresponding energy densities
    # while energy is given by user.
    def energy_pcf
      energy_from_protein +
      energy_from_carbs +
      energy_from_fat
    end
  
    def energy_from_protein
      PROTEIN_DENSITY * @protein
    end
  
    def energy_from_carbs
      CARBS_DENSITY * @carbs
    end
  
    def energy_from_fat
      FAT_DENSITY * @fat
    end
  end
end