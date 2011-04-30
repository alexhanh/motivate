class AddTrackers < ActiveRecord::Migration
  def self.up
    create_table(:trackers) do |t|
      t.string :name, :null => false
      t.boolean :private, :null => false
      t.integer :user_id
      t.string :custom_unit
    end
    
    create_table(:tracker_entries) do |t|
      t.float :value, :null => false
      t.integer :user_id, :null => false
      t.integer :tracker_id, :null => false
      t.timestamp :logged_on, :null => false
      t.string :unit, :null => false
    end
  end

  def self.down
    drop_table :tracker_entries
    drop_table :trackers
  end
end
