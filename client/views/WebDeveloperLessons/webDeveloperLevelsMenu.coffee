Template.webDeveloperLevelsMenu.helpers
  isCurrentLevel: (lvlNum) ->
    Session.get('levelNumber') is lvlNum
  getLevelLink: (lvlNum) ->
    if lvlNum is 1
      lesson = WebDeveloperLessonsList.getLesson(1)
    if lvlNum is 2
      lesson = WebDeveloperLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(2))
    if lvlNum is 3
      lesson = WebDeveloperLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(3))

    return Router.path 'lessonWebDeveloper',
      lang: TAPi18n.getLanguage()
      _id: lesson.id
      slug: lesson.slug
      lessonType: 'web-developer'
      username: App.getCurrentUsername()
