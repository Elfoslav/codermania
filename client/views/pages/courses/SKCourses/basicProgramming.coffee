Template.basicProgramming.helpers
  courses: ->
    date = new Date(2015, 4, 14)
    today = new Date()
    if date > today
      return [
        description: """
          Kurz sa uskutoční dňa 14.5.2015 (štvrtok) v Dubnici nad Váhom v Doors pube (Školská 340).
          <br>
          Prihlásiť sa môžeš na <a href='https://www.facebook.com/events/964152560285510/' target='_blank'>Facebooku</a>.
        """
      ]