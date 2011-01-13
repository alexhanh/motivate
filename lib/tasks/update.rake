namespace :db do
  desc 'recalculating eaten counts'
  task :recompute => :environment do
    Product.all.each do |p|
      p.eaten_count = p.food_entries.count
      p.favorites_count = p.favorites.count
      p.save!
    end
    
    Recipe.all.each do |p|
      p.eaten_count = p.food_entries.count
      p.favorites_count = p.favorites.count
      p.save!
    end
  end
end
