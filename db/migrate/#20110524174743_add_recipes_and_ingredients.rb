class AddRecipesAndIngredients < ActiveRecord::Migration
  def self.up
    create_table(:recipes) do |t|
      t.references :user
      t.string :name
      
      t.float :energy
      t.float :protein
      t.float :carbs
      t.float :fat
    end
    
    create_table(:ingredients) do |t|
      t.references :recipe
      t.references :product

      t.float :value
      t.string :unit, :limit => 50
    end
  end

  def self.down
    drop_table :ingredients
    drop_table :recipes
  end
end
