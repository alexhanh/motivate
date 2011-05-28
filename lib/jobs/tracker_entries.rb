module Jobs
  class TrackerEntries
    extend Jobs::Base
    
    def self.on_create(tracker_entry_id)
      entry = TrackerEntry.includes(:user).find(tracker_entry_id)
      count = TrackerEntry.count(:conditions => ["user_id = ?", entry.user_id])
      if count > 10
        award(entry.user, :token => 'measurer', :unique => true)
      end
    end
  end
end