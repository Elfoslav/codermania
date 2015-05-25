#TODO refactor, it's similar to HTMLLevelsMenu and JSLevelsMenu
Template.CSSLevelsMenu.helpers
  isCurrentLevel: (lvlNum) ->
    Session.get('levelNumber') is lvlNum
  getLevelLink: (lvlNum) ->
    if lvlNum is 1
      lesson = CSSLessonsList.getLesson(1)
    if lvlNum is 2
      lesson = CSSLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(2))
    if lvlNum is 3
      lesson = CSSLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(3))

    return Router.path 'lessonCSS',
      lang: TAPi18n.getLanguage()
      _id: lesson.id
      slug: lesson.slug
      lessonType: 'css'
      username: App.getCurrentUsername()
