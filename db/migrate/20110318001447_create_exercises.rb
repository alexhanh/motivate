class CreateExercises < ActiveRecord::Migration
  def self.up
    create_table(:exercise_entries) do |t|
      t.references :user
      t.references :exercise

      t.float :energy, :null => false
      t.timestamp :exercised_at, :null => false
      
      t.integer :hours
      t.integer :minutes
      t.integer :seconds
    end
    
    create_table(:exercises) do |t|
      t.string :name, :limit => 50, :null => false
      t.float :met, :null => false
    end
  end

  def self.down
    drop_table :exercise_entries
    drop_table :exercises
  end
end
