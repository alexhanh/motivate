module Jobs
  class Consumables
    extend Jobs::Base
    
    def self.on_favorite(favorable_id, favorable_type)
      # TODO: make more generic (recipes)
      product = Product.includes(:user).find(favorable_id)
      favorites = product.favorites.count
      if favorites > 10
        award(product.user, {:token => "popular_product", :source => product}, {:unique => true, :source_id => product.id})
      end
    end
  end
end