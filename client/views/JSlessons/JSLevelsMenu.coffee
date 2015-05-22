Template.JSLevelsMenu.helpers
  isCurrentLevel: (lvlNum) ->
    Session.get('levelNumber') is lvlNum
  getLevelLink: (lvlNum) ->
    if lvlNum is 1
      lesson = LessonsList.getLesson(1)
      return Router.path 'lesson',
        lang: TAPi18n.getLanguage()
        _id: lesson.id
        slug: lesson.slug
        username: App.getCurrentUsername()
    if lvlNum is 2
      lesson = LessonsList.getLesson(Lesson.getJSLevelStartLessonNum(2))
      return Router.path 'lesson',
        lang: TAPi18n.getLanguage()
        _id: lesson.id
        slug: lesson.slug
        username: App.getCurrentUsername()
    if lvlNum is 3
      lesson = LessonsList.getLesson(Lesson.getJSLevelStartLessonNum(3))
      return Router.path 'lesson',
        lang: TAPi18n.getLanguage()
        _id: lesson.id
        slug: lesson.slug
        username: App.getCurrentUsername()
