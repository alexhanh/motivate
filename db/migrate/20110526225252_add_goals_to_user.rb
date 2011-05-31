class AddGoalsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :weight_change_rate, :float, :default => 0.0
  end

  def self.down
    remove_column :users, :weight_change_rate
  end
end
