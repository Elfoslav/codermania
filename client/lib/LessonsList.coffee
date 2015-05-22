class @LessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    if Router.current()?.route.getName() is 'lessonHTML'
      return HTMLLessonsList.getLessons()
    if Router.current()?.route.getName() is 'lessonCSS'
      return CSSLessonsList.getLessons()
    return JSLessonsList.getLessons()

  @getLesson: (number) ->
    LessonsList.getLessons()[number - 1]

  #@number - lesson number
  @getFirstExercise: (number) ->
    lesson = LessonsList.getLesson(number)
    return lesson.exercises?[lesson.id + 'e1']

  @getCurrentExerciseNumber: ->
    exerciseId = Session.get('exerciseId')
    if exerciseId
      return parseInt exerciseId[exerciseId.length - 1]
    return 0

  @getNextExerciseId: (exerciseId) ->
    lesson = LessonsList.getLesson(Session.get 'lessonNumber')
    exerciseNum = parseInt exerciseId[exerciseId.length - 1]
    nextExerciseId = lesson.id + 'e' + (exerciseNum + 1)
