class AddBirthAndSexToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :birthday, :date
    add_column :users, :gender, :boolean # Male = 1, Female = 0
  end

  def self.down
    remove_column :users, :birthday
    remove_column :users, :gender
  end
end
