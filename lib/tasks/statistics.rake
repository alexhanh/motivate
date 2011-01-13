namespace :statistics do
  desc 'on users: total'
  task :users => :environment do
    puts "Users: %i" % [User.count]
  end

  desc 'on content: products, recipes, favorites'
  task :content => :environment do
    puts "Products: %i" % [Product.count]
    puts "Recipes: %i" % [Recipe.count]
    puts "Food logs: %i" % [FoodEntry.count]
    puts "Favorites: %i" % [Favorite.count]
  end
  task :genders => :environment do
    genders = Person.collection.group(['profile.gender'], {}, {:count => 0}, 'function(o,p) { p.count++; }', true )
    genders.sort!{|a,b| a['profile.gender'].to_s <=> b['profile.gender'].to_s}
    genders.each do |gender|
      puts "%s: %i" % [gender['profile.gender']||'none given', gender['count']]
    end
  end
end
