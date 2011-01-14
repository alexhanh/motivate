module Jobs
  class TestJob
    @queue = :file_serve

    def self.perform(msg)
      p "Performing job: #{msg}"
    end
  end
end