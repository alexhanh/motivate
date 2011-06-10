class AddAchievements < ActiveRecord::Migration
  def self.up
    create_table(:achievements) do |t|
      t.references :user
      t.string :token
      t.string :achievement_type, :limit => 6, :null => false
      
      t.references :source, :polymorphic => true
    end
  end

  def self.down
    drop_table :achievements
  end
end
