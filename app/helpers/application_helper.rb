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
  
  def link_to_add_to_favorites(favoritable)
    link_to "Lisää suosikkeihin",
            add_to_favorites_path(:favorable_type => favoritable.class.name.constantize, :favorable_id => favoritable.id), 
            :method => :post#, :remote => true
  end
  
  def link_to_remove_from_favorites(favoritable)
    link_to "Poista suosikeista",
            remove_from_favorites_path(:favorable_type => favoritable.class.name.constantize, :favorable_id => favoritable.id), 
            :method => :post#, :remote => true
  end
  
  def quantity_unit(o)
    s = "#{o.quantity.round(1)}"
    if o.unit.custom?
      s += " " + o.custom_unit
    else
      s += o.unit.unit_name
    end
    return s
  end
  
  def default_unit(o)
    data = o.compute_data
    scale = 1
    unit_name = o.unit_name
    if o.unit.weight?
      scale = 100
      unit_name = 'g'
      data = data.scale(100.0)
    elsif o.unit.volume?
      scale = 100
      unit_name = 'ml'
      #todo: fix me!
     # Units::convert()
     # data = data.scale(10.0)
    else
    end
    
    parent = ""
    parent = " (#{o.parent_quantity} #{o.display_parent_unit})" unless o.root?
    
    s = "<tr>" +
        "<td>#{scale} #{unit_name}#{parent}</td>" +
        "<td>#{quantity_string(data.energy)}</td>" +
        "<td>#{quantity_string(data.carbs)}</td>" +
        "<td>#{quantity_string(data.protein)}</td>" +
        "<td>#{quantity_string(data.fat)}</td>" +
        "</tr>"
    return s
  end
  
  def quantity_string(float)
    if float < 0.1 && float > 0.0
      return "<0.1" 
    else
      return float.round(1).to_s
    end
  end
end
