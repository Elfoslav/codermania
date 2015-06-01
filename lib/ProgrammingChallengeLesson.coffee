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
    if lines.indexOf('\n') != -1
      lines = $('.output').html().split('\n')

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

    unless resultMsg or success
      resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    return resultMsg || success
