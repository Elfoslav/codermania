class @Lesson
  ###
  #  @param opts Object
  #    lesson
  #    code
  #  @returns true on success, string message on failure
  ###
  @checkAssignment: (opts) ->
    if Lesson.isJSLesson()
      return JSLesson.checkAssignment opts
    if Lesson.isHTMLLesson()
      return HTMLLesson.checkAssignment opts
    if Lesson.isCSSLesson()
      return CSSLesson.checkAssignment opts
    if Lesson.isProgrammingChallengeLesson()
      return ProgrammingChallengeLesson.checkAssignment opts

  @isJSLesson: ->
    unless Meteor.isClient
      throw new Meteor.Error('not-allowed-call',
        'This method can be only called from the client')
    Router.current().route.getName() is 'lessonJS'

  @isHTMLLesson: ->
    unless Meteor.isClient
      throw new Meteor.Error('not-allowed-call',
        'This method can be only called from the client')
    Router.current().route.getName() is 'lessonHTML'

  @isCSSLesson: ->
    unless Meteor.isClient
      throw new Meteor.Error('not-allowed-call',
        'This method can be only called from the client')
    Router.current().route.getName() is 'lessonCSS'

  @isProgrammingChallengeLesson: ->
    unless Meteor.isClient
      throw new Meteor.Error('not-allowed-call',
        'This method can be only called from the client')
    Router.current().route.getName() is 'lessonProgrammingChallenge'

  @getType: ->
    unless Meteor.isClient
      throw new Meteor.Error('not-allowed-call',
        'This method can be only called from the client')
    return 'javascript' if Lesson.isJSLesson()
    return 'html' if Lesson.isHTMLLesson()
    return 'css' if Lesson.isCSSLesson()
    return 'programming-challenge' if Lesson.isProgrammingChallengeLesson()

  ###
  # @param num Integer
  # @param lessons Array of lessons
  ###
  @setLesson: (num, lessons, editor) ->
    Session.set('lessonNumber', num)
    lesson = lessons[num - 1]
    userLesson = Lesson.getUserLesson(lesson.id)
    if Router.current().params.username and userLesson
      editor.setValue(userLesson.code)
    else
      editor.setValue(lesson.initCode)
    editor.selection.clearSelection()
    if $('.nav a[href="#theory"]').hasClass 'active'
      $('.nav a[href="#theory"]').tab('show')

  @getUserLesson: (lessonId) ->
    if Lesson.isHTMLLesson()
      return UserHTMLLessons.findOne({ id: lessonId })
    if Lesson.isCSSLesson()
      return UserCSSLessons.findOne({ id: lessonId })
    if Lesson.isProgrammingChallengeLesson()
      return UserProgrammingChallengeLessons.findOne({ id: lessonId })
    username = Router.current().params.username
    user = Meteor.users.findOne({ username: username })
    user?.lessons?[lessonId]

  @initAssignment: (lessonNumber, lessons, editor) ->
    lesson = lessons[lessonNumber - 1]
    userLesson = Lesson.getUserLesson(lesson.id)
    if userLesson
      editor.setValue(userLesson.code)
    else if lesson.initAssignmentCode
      editor.setValue(lesson.initAssignmentCode)
    editor.selection.clearSelection()

  @initExercise: (lesson, exercise, editor) ->
    userExercise = Lesson.getUserExercise(lesson, exercise?.id)
    if userExercise?.code
      editor.setValue(userExercise.code)
      editor.selection.clearSelection()

  @getJSLevelStartLessonNum: (lvlNum) ->
    if lvlNum is 2
      return 9
    if lvlNum is 3
      return 17
    return 1
  @getJSLevelNum: (lessonNum) ->
    if lessonNum < Lesson.getJSLevelStartLessonNum(2)
      return 1
    if lessonNum >= Lesson.getJSLevelStartLessonNum(2) and
      lessonNum < Lesson.getJSLevelStartLessonNum(3)
        return 2
    if lessonNum >= Lesson.getJSLevelStartLessonNum(3)
      return 3

  @showLesson: (lessonNum, levelNum) ->
    if lessonNum < Lesson.getJSLevelStartLessonNum(2)
      return 1 == levelNum
    if lessonNum >= Lesson.getJSLevelStartLessonNum(2) and
      lessonNum < Lesson.getJSLevelStartLessonNum(3)
        return 2 == levelNum
    if lessonNum >= Lesson.getJSLevelStartLessonNum(3)
      return 3 == levelNum

  @getLessonPoints: (lessonNum, lessonType) ->
    if lessonType is 'javascript'
      return lessonNum * 2
    else
      return lessonNum

  @getUserExercise: (lesson, exerciseId) ->
    user = Meteor.users.findOne({ username: Router.current().params.username })
    user?.lessons?[lesson.id]?.exercises?[exerciseId]
