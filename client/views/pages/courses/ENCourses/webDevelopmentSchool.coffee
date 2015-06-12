Template.webDevelopmentSchool.helpers
  freeSpots: ->
    freeSpots = @capacity - @userIds?.length
    console.log 'free spots', freeSpots
    if freeSpots is 1
      return '1 seat left.'
    if freeSpots > 1
      return "#{freeSpots} seats left."