Template.summerWebDevSchoolApplicationInstructions.helpers
  freeSpots: ->
    freeSpots = @capacity - @userIds?.length
    if freeSpots is 1
      return 'Ešte je 1 voľné miesto.'
    if freeSpots > 1 and freeSpots < 5
      return "Ešte sú #{freeSpots} voľné miesta."
    if freeSpots >= 5
      return "Ešte je #{freeSpots} voľných miest."