Template.programmingChallengeLevelsMenu.helpers
  isCurrentLevel: (lvlNum) ->
    Session.get('levelNumber') is lvlNum
  getLevelLink: (lvlNum) ->
    if lvlNum is 1
      lesson = ProgrammingChallengeLessonsList.getLesson(1)
    if lvlNum is 2
      lesson = ProgrammingChallengeLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(2))
    if lvlNum is 3
      lesson = ProgrammingChallengeLessonsList.getLesson(Lesson.getJSLevelStartLessonNum(3))

    return Router.path 'lessonProgrammingChallenge',
      lang: TAPi18n.getLanguage()
      _id: lesson.id
      slug: lesson.slug
      username: App.getCurrentUsername()
