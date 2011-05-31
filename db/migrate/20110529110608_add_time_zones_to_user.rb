class AddTimeZonesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string, :limit => 255, :default => 'Helsinki'
  end

  def self.down
    remove_column :users, :time_zone
  end
end
