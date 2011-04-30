module FoodHelper
  def all_food_units
    @@all_foods ||= [Units.g, Units.dl, Units.ml, Units.tsp, Units.tbsp, Units.cup]
  end
  
  # Take a consumable (that has many food units), inspects each supported
  # type and returns all supported units.
  def to_units(consumable)
    types = consumable.food_units.map{|fu| fu.quantity.type}
    custom_units = consumable.food_units.select{|fu| fu.quantity.custom?}.map{|fu| fu.quantity.unit} 
    common_units = all_food_units.select{|unit| types.include?(unit.type)}
    custom_units + common_units
  end
  
  def unit_select_list(consumable)
    # returns all common units that aren't already defined by consumable.food_units
    all_food_units - to_units(consumable)
  end
  
  def default_unit(food_unit)
    # compute data, or whatever that fetches .food_data or computes it through ancestry
    # at this point we have data per food_unit.quantity
    # convert this to 100 grams, if it's weight type
    # convert this to 100 ml, if it's volume type
    # convert this to 1 X, if it's custom type
    # get scale using old.value / new.value and scale parent quantity accordingly
    
    
    
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
      
      data = data.scale(0.1)
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
end