class AddProducts < ActiveRecord::Migration
  def self.up
    create_table(:products) do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
    end
    
    create_table(:food_units) do |t|
      t.string :ancestry
      
      t.float :value
      t.string :unit
      t.float :parent_value
      t.string :parent_unit
      
      t.integer :consumable_id, :null => false
      t.string :consumable_type, :null => false
      
      t.float :energy
      t.float :protein
      t.float :carbs
      t.float :fat
    end
    
    add_index :food_units, :ancestry
  end

  def self.down
    remove_index :food_units, :ancestry
    drop_table :food_units
    drop_table :products
  end
end
