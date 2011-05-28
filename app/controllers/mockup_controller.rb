class MockupController < ApplicationController
  def room
    r = current_user.food_entries.select("SUM(energy) AS total_energy, SUM(protein) AS total_protein")[0]
    
    @total_energy = r.total_energy
  end
end
