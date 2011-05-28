class AddWeightUnitToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :weight_unit_unit, :string, :default => Units.kg.id
    add_column :users, :energy_unit_unit, :string, :default => Units.kcal.id
    add_column :users, :length_unit_unit, :string, :default => Units.km.id
  end

  def self.down
    remove_column :users, :weight_unit_unit
    remove_column :users, :energy_unit_unit
    remove_column :users, :length_unit_unit
  end
end
