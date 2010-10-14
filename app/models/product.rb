class Product
  include MongoMapper::Document
  include Support::Consumable
  
  key :name
  
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
  
end
