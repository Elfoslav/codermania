Template.starTriangle5Assignment.helpers
  triangle: ->
    spaces = 19
    str = ''
    i = 1
    while i <= 20
      str += ' '.repeat(spaces--) + '*'.repeat(i++) + '<br/>'
    return str