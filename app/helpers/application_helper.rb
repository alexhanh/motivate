module ApplicationHelper
  def unit_select_list(consumable, f)
    has_weight = false
    has_volume = false
    consumable.serving_sizes.each do |s|
      has_weight = true if s.weight?
      has_volume = true if s.volume?
    end
    
    units = []
    units = units + Units::CommonVolume unless has_volume
    units = units + Units::CommonWeight unless has_weight

    f.collection_select :unit, units, :to_s, :unit_name
  end
end