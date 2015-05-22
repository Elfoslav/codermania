Template.lessonsMenu.helpers
  lessons: ->
    i = 1;
    return LessonsList.getLessons().map((lesson) ->
      lesson.show = Lesson.showLesson(i, Session.get('levelNumber'))
      lesson.i = i++;
      return lesson
    )
  isCurrentLesson: (index) ->
    return Session.get('lessonNumber') == index
  lessonType: ->
    Router.current().data().lessonType
