Template.summerWebDevelopmentSchool.helpers
  freeSpots: ->
    freeSpots = @group?.capacity - @group?.userIds?.length
    if freeSpots is 1
      return '1 miesto voľné.'
    if freeSpots > 1 and freeSpots < 5
      return "#{freeSpots} miesta voľné."
    if freeSpots >= 5
      return "#{freeSpots} miest voľných."