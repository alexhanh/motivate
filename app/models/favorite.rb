# alternative implementation allowing easier quering for favables favoriting users
# https://gist.github.com/09d2a16604787d770eaa
# https://gist.github.com/a6d78000041e5ba20ae1

class Favorite
  include MongoMapper::Document
  
  key :simple_user_id, ObjectId
  belongs_to :simple_user, :class_name => "SimpleUser"
  
  key :favorable_id, ObjectId
  key :favorable_type, String
  belongs_to :favorable, :polymorphic => true
end