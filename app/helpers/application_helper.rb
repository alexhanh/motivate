# coding: utf-8
module ApplicationHelper  
  def link_to_eat(consumable)    
    link_to "Syö", send("new_#{consumable.class.name.downcase}_food_entry_path".to_sym, consumable), :remote => true
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
  
  def quantity_string(float)
    if float < 0.1 && float > 0.0
      return "<0.1" 
    else
      return float.round(1).to_s
    end
  end
  
  def days_ago(date)
    distance_in_days = ((Time.zone.now - date)/(60*60*24)) - 1
    
    return "Tänään" if distance_in_days <= 0
    return "Eilen" if distance_in_days <= 1
    return I18n.t('datetime.distance_in_words.x_days', :count => distance_in_days.ceil) + " sitten"
  end
  
  def user_unit(quantity)
    return quantity.convert(current_user.weight_unit) if quantity.weight?
    return quantity.convert(current_user.energy_unit) if quantity.energy?
    quantity
  end
end
