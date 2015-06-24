Template.webDevelopmentSchool.helpers
  freeSpots: ->
    freeSpots = @capacity - @userIds?.length
    if freeSpots is 1
      return '1 spot left.'
    if freeSpots is 0 or freeSpots > 1
      return "#{freeSpots} spots left."