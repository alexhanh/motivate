class CreateFoodEntries < ActiveRecord::Migration
  def self.up
    create_table(:food_entries) do |t|
      t.references :user
      t.references :consumable, :polymorphic => true

      t.float :value
      t.string :unit, :limit => 50
      
      t.timestamp :eaten_at, :null => false
      
      t.float :energy
      t.float :protein
      t.float :carbs
      t.float :fat
    end
    
    add_index :food_entries, :eaten_at
  end

  def self.down
    remove_index :food_entries, :eaten
    drop_table :food_entries
  end
end
