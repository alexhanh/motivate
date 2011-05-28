class AddGoalsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :weight_change_rate_value, :float, :default => 0.0
    add_column :users, :weight_change_rate_unit, :string, :default => Units.kg.id
  end

  def self.down
    remove_column :users, :weight_change_rate_value
    remove_column :users, :weight_change_rate_unit
  end
end
