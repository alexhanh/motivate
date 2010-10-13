# coding: utf-8
#Factory.define :user do |f|
#  f.sequence(:username) { |n| "alex#{n}" }
#  #f.sequence(:email) { |n| "alex#{n}@foo.com" }
#  f.email "something@google.com"
#  f.password "qwerty123"
#end

Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

#class Post
#  include MongoMapper::Document
#  
#  one :answer
#end

#class Answer
#  include MongoMapper::Document
#  
#  
#end

Factory.define :nutrition_data do |f|
  f.energy  50
  f.carbs   10
  f.protein 1
  f.fat     7
end

Factory.define :candy, :class => ServingSize do |f|
  f.unit Units::CUSTOM
  f.nutrition_data Factory(:nutrition_data)
  f.sequence(:singular) {|n| "candy#{n}"}
  f.sequence(:plural) {|n| "candies#{n}"}
end

Factory.define :gramma, :class => ServingSize do |f|
  f.unit Units::GRAM
  f.nutrition_data Factory(:nutrition_data)
end

Factory.define :litra, :class => ServingSize do |f|
  f.unit Units::LITER
  f.nutrition_data Factory(:nutrition_data)
end

Factory.define :aakkonen, :class => ServingSize do |f|
  f.unit Units::CUSTOM
  f.parent_amount 2.5
  f.singular "aakkonen"
  f.plural "aakkosta"
end

Factory.define :pussi, :class => ServingSize do |f|
  f.unit Units::CUSTOM
  f.parent_amount 30
  f.singular "pussi"
  f.plural "pussia"
end

Factory.define :aakkoset, :class => Product do |f|
  f.sequence(:name) {|n| "Aakkoset#{n}"}
  f.serving_sizes [Factory(:gramma), Factory(:aakkonen), 
                   Factory(:pussi), Factory(:litra)]
  
  f.after_build do |n|
    n.serving_sizes[1].parent = n.serving_sizes[0]
    n.serving_sizes[2].parent = n.serving_sizes[1]
  end
end

Factory.define :maito, :class => Product do |f|
  f.name "Maito"
  f.serving_sizes [Factory(:litra)]
end

Factory.define :maito_ainesosa, :class => Ingredient do |f|
  f.quantity 4
  f.unit Units::DECILITER
  #f.product Factory(:maito)
end

Factory.define :aakkonen_ainesosa, :class => Ingredient do |f|
  f.quantity 10
  f.custom_unit_name "aakkosta"
  f.unit Units::CUSTOM
  #f.product Factory(:aakkoset)
end

Factory.define :aakkospirtelo, :class => Recipe do |f|
  f.sequence(:name) {|n| "Aakkospirtelo#{n}"}
  
  f.servings_produced 4
  f.serving_sizes [Factory(:litra)]
  
  f.ingredients [Factory(:maito_ainesosa), Factory(:aakkonen_ainesosa)]
  
  f.after_build do |n|
    n.ingredients[0].product = Factory(:maito)
    n.ingredients[1].product = Factory(:aakkoset)
  end
end












































