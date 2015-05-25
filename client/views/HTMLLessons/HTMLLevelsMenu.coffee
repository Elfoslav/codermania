Template.HTMLLevelsMenu.helpers
  isCurrentLevel: (lvlNum) ->
    Session.get('levelNumber') is lvlNum
  getLevelLink: (lvlNum) ->
    if lvlNum is 1
      lesson = HTMLLessonsList.getLesson(1)
    if lvlNum is 2
      lesson = HTMLLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(2))
    if lvlNum is 3
      lesson = HTMLLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(3))

    return Router.path 'lessonHTML',
      lang: TAPi18n.getLanguage()
      _id: lesson.id
      slug: lesson.slug
      lessonType: 'html'
      username: App.getCurrentUsername()
