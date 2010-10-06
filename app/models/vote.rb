class Vote
  include MongoMapper::Document
  
  key :user_id, ObjectId
  belongs_to :user
  
  key :voteable_id, ObjectId
  key :voteable_type, String
  belongs_to :voteable, :polymorphic => true
  
  validates_presence_of :user_id, :voteable_id, :voteable_type
  
  validate :should_be_unique

  protected
  def should_be_unique
    vote = Vote.first( :voteable_type => self.voteable_type,
                       :voteable_id => self.voteable_id,
                       :user_id     => self.user_id )

    valid = (vote.nil? || vote.id == self.id)
    if !valid
      self.errors.add(:voteable, "You already voted this #{self.voteable_type}")
    end
  end
end
