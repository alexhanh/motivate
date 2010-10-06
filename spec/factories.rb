#Factory.define :user do |f|
#  f.sequence(:username) { |n| "alex#{n}" }
#  #f.sequence(:email) { |n| "alex#{n}@foo.com" }
#  f.email "something@google.com"
#  f.password "qwerty123"
#end

Factory.define :nutrition_data do |f|
  f.energy  50
  f.carbs   10
  f.protein 1
  f.fat     7
end

Factory.define :gramma, :class => ServingSize do |f|
  #TODO: refactor this
  f.unit 1
  f.nutrition_data Factory.create(:nutrition_data)
end

Factory.define :aakkonen, :class => ServingSize do |f|
  f.unit 3
  f.parent_amount 2.5
  f.singular "aakkonen"
  f.plural "aakkosta"
end

Factory.define :pussi, :class => ServingSize do |f|
  f.unit 3
  f.parent_amount 30
  f.singular "pussi"
  f.plural "pussia"
end

Factory.define :aakkoset, :class => Product do |f|
  f.name "Aakkoset"
  f.serving_sizes [Factory(:gramma), Factory(:aakkonen), Factory(:pussi)]
  
  f.after_build do |n|
    n.serving_sizes[1].parent = n.serving_sizes[0]
    n.serving_sizes[2].parent = n.serving_sizes[1]
  end
end
