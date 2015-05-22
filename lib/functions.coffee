@extractSubstring = (startChar, endChar, str) ->
  str.substring(str.lastIndexOf(startChar)+1,str.lastIndexOf(endChar))