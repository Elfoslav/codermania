class @CodeChecker
  @hasIndentation: (str, spaces) ->
    spaces = spaces || 2
    #replace tabs with two spaces
    str = str.replace(/\t/g, '  ')
    hasIndentation = true
    while spaces > 0 and hasIndentation
      hasIndentation = str?[spaces - 1] == ' '
      spaces--
    return hasIndentation and spaces is 0