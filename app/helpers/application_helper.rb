# coding: utf-8
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
  
  def link_to_eat(consumable)    
    link_to "Syö", send("new_#{consumable.class.name.downcase}_food_entry_path".to_sym, consumable)
  end
  
  def quantity_unit(o)
    p o
    p o.unit
    p o.unit.unit_name
    s = "#{o.quantity}"
    if o.unit.custom?
      s += o.custom_unit
    else
      s += o.unit.unit_name
    end
    return s
  end
end