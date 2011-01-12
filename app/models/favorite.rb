# alternative implementation allowing easier quering for favables favoriting users
# https://gist.github.com/09d2a16604787d770eaa
# https://gist.github.com/a6d78000041e5ba20ae1

class Favorite
  include MongoMapper::Document
  
  key :user_id, ObjectId# :index => true
  belongs_to :user
  
  key :favorable_id, ObjectId
  key :favorable_type, String
  belongs_to :favorable, :polymorphic => true
  
  validate :should_be_unique
  
  protected
  def should_be_unique
    favorite = Favorite.first(:favorable_type => self.favorable_type,
                              :favorable_id => self.favorable_id,
                              :user_id     => self.user_id )

    valid = (favorite.nil? || favorite.id == self.id)
    if !valid
      self.errors.add(:favorable, "You already favorited this #{self.favorable_type}")
    end
  end
end