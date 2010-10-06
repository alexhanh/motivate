class Meal
  # has a name
  # contains a list of products and recipes with default quantities
  # should probably be embedded with user (can only have fairly limited amount)
  
  # example
  {
    :name => 'Breakfast',
    :items => [
      {
        :id => '12',
        :type => 'Product',
        :name => 'Soy milk',
        :default_quantity => '2',
        :default_unit => 'dl'
      },    
      {
        :id => '232',
        :type => 'Product',
        :name => 'Green tea',
        :default_quantity => '1,5',
        :default_unit => 'dl'       
      },
      {
        :id => '2',
        :type => 'Recipe',
        :name => 'Omelet',
        :default_quantity => '1',
        :default_unit => 'kpl'    
      },
    ]
  }
  
  # products, recipes and meals are consumable.. meaning a food log entry can reference them
end
