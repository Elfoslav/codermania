class @HTMLLesson
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

    unless resultMsg or success
      resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    return resultMsg || success
