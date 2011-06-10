class AddEstimatedToExerciseEntries < ActiveRecord::Migration
  def self.up
    add_column :exercise_entries, :estimated, :boolean, :null => false
  end

  def self.down
    remove_column :exercise_entries, :estimated
  end
end
