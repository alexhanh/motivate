module AchievementsHelper
  def achievements(user)
    counts = user.achievement_counts
    s = ''
    s += 'K' + counts['gold'].to_s if counts.has_key?('gold')
    s += 'H' + counts['silver'].to_s if counts.has_key?('silver')
    s += 'P' + counts['bronze'].to_s if counts.has_key?('bronze')
    s
  end
end