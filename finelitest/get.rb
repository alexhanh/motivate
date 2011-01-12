# include Rails environment
require File.expand_path("../../config/environment", __FILE__)

#doc = Nokogiri::HTML(open('mitat.html'))

def assign_serving_sizes(product, unit_page)
  s = unit_page.css("th:contains('Ruokamitta')").first.parent.next_sibling

  volume_added = false
  while !s.nil?
    serving_size = ServingSize.new
    serving_size.parent_unit_proxy = (Units::GRAM).to_s

    # always grams, which is always product.serving_sizes[0]
    serving_size.parent_quantity = s.children[1].text.to_f
  
    name = s.children[0].text
    if name.casecmp("desilitra") == 0
      serving_size.unit = Units::DECILITER
    elsif name.casecmp("ruokalusikka") == 0
      serving_size.unit = Units::TABLESPOON
    elsif name.casecmp("teelusikka") == 0
      serving_size.unit = Units::TEASPOON
    else
      serving_size.unit = Units::CUSTOM
      serving_size.custom_unit = name
    end
    
    if !(volume_added && serving_size.unit.volume?) || serving_size.unit.custom?
      product.serving_sizes << serving_size
    end 
    
    volume_added = true if serving_size.unit.volume?
    
    s = s.next_sibling
  end
end

def food_name(food_page)
  food_page.css("h1").first.text
end

#assumes a nokogiri doc!
def nutrition_data(food_page)
  td = food_page.css("a:contains('energia, laskennallinen')").first.parent
  energy = td.next_sibling.text
  if energy =~ /\((\d+)\)/
    energy = $1
  end

  tr = td.parent.next_sibling
  carbs = tr.children[1].text

  tr = tr.next_sibling
  fat = tr.children[1].text

  tr = tr.next_sibling
  protein = tr.children[1].text
  
  data = NutritionData.new
  data.energy = energy.to_f
  data.carbs = carbs.to_f
  data.protein = protein.to_f
  data.fat = fat.to_f
  
  return data
end

def link_to_food_page(id)
  "http://www.fineli.fi/food.php?foodid=#{id}&lang=fi"
end

def link_to_food_unit(id)
  "http://www.fineli.fi/foodunit.php?foodid=#{id}&lang=fi"
end

food_ids = []

doc = Nokogiri::HTML(open('index.html'))
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
  
  @product = Product.new
  @product.name = food_name(food_page)
  grams_ss = ServingSize.new
  grams_ss.unit = Units::GRAM
  grams_ss.quantity = 100
  grams_ss.nutrition_data = nutrition_data(food_page)
  
  @product.serving_sizes << grams_ss
  @product.save!
  
  assign_serving_sizes(@product, unit_page)
  @product.save!
  counter = counter + 1
end

