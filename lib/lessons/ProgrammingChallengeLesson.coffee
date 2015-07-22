class @ProgrammingChallengeLesson
  ###
  #  @param opts Object
  #    lesson
  #    code
  #  @returns true on success, string message on failure
  ###
  @checkAssignment: (opts) ->
    opts.code = $.trim(opts.code)
    lesson = opts.lesson
    success = false
    resultMsg = ''

    lines = $('.output').html().split(' <br>')
    output = $('.output').html().replace(/\s<br>/g, '')
    if lines.indexOf('\n') != -1
      lines = $('.output').html().split('\n')
      output = $('.output').html().replace(/\\n/g, '')

    if lesson.id is '1a'
      if lines[0] != '*'
        return 'Output of line 1 is not "*"'
      if lines[1] != '**'
        return 'Output of line 2 is not "**"'
      if lines[2] != '***'
        return 'Output of line 3 is not "***"'
      if lines[3] != '****'
        return 'Output of line 4 is not "****"'
      if lines[4].replace(' <br>', '') != '*****'
        return 'Output of line 5 is not "*****"'

      return success = true

    if lesson.id is '1b'
      if lines[0] != '    *'
        return 'Output of line 1 is not "    *"'
      if lines[1] != '   **'
        return 'Output of line 2 is not "   **"'
      if lines[2] != '  ***'
        return 'Output of line 3 is not "  ***"'
      if lines[3] != ' ****'
        return 'Output of line 4 is not " ****"'
      if lines[4].replace(' <br>', '') != '*****'
        return 'Output of line 5 is not "*****"'

      return success = true

    if lesson.id is '1c'
      if lines[0] != '*****'
        return 'Output of line 1 is not "*****"'
      if lines[1] != '****'
        return 'Output of line 2 is not "****"'
      if lines[2] != '***'
        return 'Output of line 3 is not "***"'
      if lines[3] != '**'
        return 'Output of line 4 is not "**"'
      if lines[4].replace(' <br>', '') != '*'
        return 'Output of line 5 is not "*"'

      return success = true

    if lesson.id is '1d'
      if lines[0] != '*****'
        return 'Output of line 1 is not "*****"'
      if lines[1] != ' ****'
        return 'Output of line 2 is not " ****"'
      if lines[2] != '  ***'
        return 'Output of line 3 is not "  ***"'
      if lines[3] != '   **'
        return 'Output of line 4 is not "   **"'
      if lines[4].replace(' <br>', '') != '    *'
        return 'Output of line 5 is not "    *"'

      return success = true

    if lesson.id is '1e'
      if lines[0] != '    *'
        return 'Output of line 1 is not "    *"'
      if lines[1] != '   ***'
        return 'Output of line 2 is not "   ***"'
      if lines[2] != '  *****'
        return 'Output of line 3 is not "  *****"'
      if lines[3] != ' *******'
        return 'Output of line 4 is not " *******"'
      if lines[4].replace(' <br>', '') != '*********'
        return 'Output of line 5 is not "*********"'

      return success = true

    if lesson.id is '1f'
      spaces = 19
      str = ''
      i = 1
      while i <= 20
        expectedLine = ' '.repeat(spaces--) + '*'.repeat(i++)
        console.log 'expectedLine: ', expectedLine
        if lines[i - 2] != expectedLine
          console.log 'lines[i - 1]', lines[i - 1]
          console.log 'expectedLine: ', expectedLine
          return "Output of line #{i - 1} is not #{expectedLine}"

      return success = true

    if lesson.id is '1g'
      str = ''
      for i in [1..100]
        if i % 15 is 0
          str += "FizzBuzz"
        else if i % 3 is 0
          str += "Fizz"
        else if i % 5 is 0
          str += "Buzz"
        else
          str += i
      if output != str
        return "The result is wrong. Ask for help if you are lost."
      return success = true

    unless resultMsg or success
      resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    return resultMsg || success
