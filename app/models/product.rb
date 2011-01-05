class Product
  include MongoMapper::Document
  include Support::Consumable
  
  key :name, String
  
  key :user_id
  belongs_to :user

  many :ingredients, :class_name => 'Ingredient', :foreign_key => :product_id
  
  validates_presence_of :name
   
  # Find all recipes with ingredient
  # Recipe.find("ingredients" => { :$elemMatch => {"_id" => "salt"} })
  
  #/////////////////////////
  # Validations
  #/////////////////////////
 
  def compute_data(quantity, unit, custom_name=nil)
    wanted_type = unit.unit_type
    self.serving_sizes.each do |s|
      if s.unit.unit_type == wanted_type
        if unit.custom?
          if (custom_name.casecmp(s.singular) == 0 ||
              custom_name.casecmp(s.plural) == 0)
            return s.compute_data(quantity) 
          end
        else
          return s.compute_data(Units::to_base(quantity, unit))
        end
      end
    end
  end
  
  #//////
  # Search
  #//////
  #https://gist.github.com/raw/269456/960c1a0ff323af6f3f40af91e2b3a7f3afea3bb9/finders3.rb
  #http://markwatson.com/blog/2009/11/mongodb-has-good-support-for-indexing.html
  #http://www.2dconcept.com/articles/12-ruby_on_rails_mongo_mapper
  def self.search(search)
    if search
      where(:name => /#{Regexp.escape(search)}/i)
    else
      where()
    end
  end
end
