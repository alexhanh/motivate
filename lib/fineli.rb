# include Rails environment
# require File.expand_path("../../config/environment", __FILE__)


#doc = Nokogiri::HTML(open('mitat.html'))

class Fineli
  def assign_food_units(product, unit_page)
    s = unit_page.css("th:contains('Ruokamitta')").first.parent.next_sibling

    volume_added = false
    while !s.nil?
      food_unit = FoodUnit.new
      # food_unit.parent_unit_proxy = (Units::GRAM).to_s

      # always grams, which is always product.serving_sizes[0]
      # serving_size.parent_quantity = s.children[1].text.to_f
      grams = s.children[1].text.to_f.g
  
      food_unit.value = 1.0
  
      name = s.children[0].text
    
      if name.casecmp("desilitra") == 0
        food_unit.unit = Units.dl.id
      elsif name.casecmp("ruokalusikka") == 0
        food_unit.unit = Units.tablespoon.id
      elsif name.casecmp("teelusikka") == 0
        food_unit.unit = Units.teaspoon.id
      else
        food_unit.unit = name
      end

      food_unit.food_data = product.compute_data(grams)
    
      if !(volume_added && food_unit.quantity.volume?) || food_unit.quantity.custom?
        product.food_units << food_unit
      end 
    
      volume_added = true if food_unit.quantity.volume?
    
      s = s.next_sibling
    end
  end

  def food_name(food_page)
    food_page.css("h1").first.text
  end

  #assumes a nokogiri doc!
  #todo: handle fields with <0.1
  def food_data(food_page)
    td = food_page.css("a:contains('energia, laskennallinen')").first.parent
    energy = td.next_sibling.text
    if energy =~ /\((.+)\)/
      energy = $1
    end

    tr = td.parent.next_sibling
    carbs = parse_number(tr.children[1].text)

    tr = tr.next_sibling
    fat = parse_number(tr.children[1].text)

    tr = tr.next_sibling
    protein = parse_number(tr.children[1].text)
  
    Food::Data.new(energy.to_f, protein, carbs, fat)
  end
  
  def parse_number(s)
    return 0.0 if s[0] == '<'
    s.to_f
  end

  def link_to_food_page(id)
    "http://www.fineli.fi/food.php?foodid=#{id}&lang=fi"
  end

  def link_to_food_unit(id)
    "http://www.fineli.fi/foodunit.php?foodid=#{id}&lang=fi"
  end

  def run
    food_ids = []
  
    doc = Nokogiri::HTML(open('./lib/index.html'))
    doc.css('a[href*="food.php?foodid="]').each do |link|
      if link['href'] =~ /(\d+)/
        food_ids << $1
      end
    end
  
    counter = 1
    food_ids.each do |food_id|
      p "Food: #{counter}, id: #{food_id}"
      food_page = Nokogiri::HTML(open(link_to_food_page(food_id)))
      unit_page = Nokogiri::HTML(open(link_to_food_unit(food_id)))
  
      p link_to_food_page(food_id)
  
      @product = Product.new(:user => User.first)
      @product.name = food_name(food_page)
      food_unit = FoodUnit.new(:quantity => 100.g)
  
      food_unit.food_data = food_data(food_page)
  
      @product.food_units << food_unit
      @product.save!
  
      assign_food_units(@product, unit_page)
      @product.save!
      counter = counter + 1
    end
  end
end