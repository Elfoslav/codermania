class @CodeChecker
  #returns true if @str is indented by @spaces spaces
  @hasIndentation: (str, spaces) ->
    unless spaces is 0
      spaces = spaces || 2
    i = spaces
    #replace tabs with two spaces
    str = str.replace(/\t/g, '  ')
    hasIndentation = spaces > 0
    while i and hasIndentation
      hasIndentation = str?[i - 1] == ' '
      i--
    return hasIndentation and i is 0