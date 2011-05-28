module Jobs
  module Base
    def award(user, opts, check_opts = {})
      unique = opts.delete(:unique) || check_opts.delete(:unique)

      # Check uniqueness constraint
      ok = true
      if unique
        ok = user.achievements.where(check_opts.merge({:token => opts[:token]})).first.nil?
      end

      return unless ok
  
      user.achievements.create(opts)
    end
  end
end