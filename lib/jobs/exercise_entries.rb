# Logannut sisään X peräkkäisenä päivänä.
# On luonut X reseptiä.
# On luonut X tuotetta.
# On luonut X syömislogia.
# On laihtunut X kiloa.
# On pysynyt Y:nä päivänä X:n % päässä kaloritavoitteesta.
# On ollut rekisteröityneenä X päivää.
# On jättänyt X kommenttia.
# On suorittanut X haastetta.
# On tehnyt X punnerrusta.
# On ottanut X askelta.

module Jobs
  class ExerciseEntries
    extend Jobs::Base
    
    def self.on_create(exercise_entry_id)
      entry = ExerciseEntry.includes(:user, :exercise).find(exercise_entry_id)
      
      if entry.exercise.running? && entry.distance_q >= Quantity.new(42.195, Units.km) && entry.duration < 60*60*6
        award(entry.user, :token => 'marathonist', :unique => true)
      end

      if entry.exercise.running? && entry.user.exercise_entries.sum(:distance) > 1000
        award(entry.user, :token => 'highlander', :unique => true)
      end
    end
  end
end