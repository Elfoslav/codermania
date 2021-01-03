Template.exerciseAccordion.helpers(
  doneExercise: ->
    lesson = LessonsList.getLesson(Session.get('lessonNumber'))
    Lesson.getUserExercise(lesson, @id)?.success

  wrongExercise: ->
    lesson = LessonsList.getLesson(Session.get('lessonNumber'))
    Lesson.getUserExercise(lesson, @id)?.success is false
)

Template.exerciseAccordion.events(
  'click .panel-heading a': (e) ->
    console.log @id
    Session.set 'exerciseId', @id
    currentLesson = LessonsList.getLesson(Session.get('lessonNumber'))
    exercise = currentLesson.exercises?[@id]
    Lesson.initExercise(currentLesson, exercise, AceEditor.instance('ace-editor'))
    Session.set('exerciseSuccess', false)
)
