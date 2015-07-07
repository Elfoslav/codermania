Meteor.startup ->
  #check duplicated lesson ids
  lessons = LessonsList.getLessons()
  lessonsIds = []
  for lesson in lessons
    if lessonsIds.indexOf(lesson.id) != -1
      throw new Meteor.Error("duplicate lesson id found: #{lesson.id}")
    lessonsIds.push(lesson.id)
  #empty array
  lessonsIds = null
  Meteor.subscribe 'userData'
  Meteor.subscribe 'needHelpCount'
  Meteor.subscribe 'unreadMessagesCount'
  Meteor.subscribe 'unreadStudyGroupMessagesCount'

Accounts.ui.config
  passwordSignupFields: 'USERNAME_AND_EMAIL'

Meteor.startup ->
  num = 1
  for lesson in JSLessonsList.getLessons()
    lesson.num = num++
    JSLessonsList._collection.insert(lesson)
  num = 1
  for lesson in HTMLLessonsList.getLessons()
    lesson.num = num++
    HTMLLessonsList._collection.insert(lesson)
  num = 1
  for lesson in CSSLessonsList.getLessons()
    lesson.num = num++
    CSSLessonsList._collection.insert(lesson)
  num = 1
  for lesson in WebDeveloperLessonsList.getLessons()
    lesson.num = num++
    WebDeveloperLessonsList._collection.insert(lesson)
  num = 1
  for lesson in ProgrammingChallengeLessonsList.getLessons()
    lesson.num = num++
    ProgrammingChallengeLessonsList._collection.insert(lesson)

Template.onRendered ->
  Editor.highlightCodeInText()

Template.registerHelper 'arrayify', (obj) ->
  result = []
  for key, value of obj
    result.push({ key:key,value: value })
  return result

Template.registerHelper 'lesson', (id) ->
  lesson = LessonsList._collection.findOne({ id: id })
  return lesson if lesson
  lesson = LessonsList._collection.findOne({ id: @key })
  return lesson

Template.registerHelper 'lessonTitle', (id) ->
  return LessonsList._collection.findOne({ id: id })?.title

Template.registerHelper 'lessonId', ->
  lessons = LessonsList.getLessons()
  return lessons[Session.get('lessonNumber')]?.id

Template.registerHelper 'lessonSlug', ->
  lessons = LessonsList.getLessons()
  return lessons[Session.get('lessonNumber')]?.slug

Template.registerHelper 'lang', (id) ->
  lang = TAPi18n.getLanguage()
  return if (lang == 'en') then '' else lang

Template.registerHelper 'userId', ->
  Meteor.userId() || undefined

Template.registerHelper 'username', ->
  App.getCurrentUsername()

Template.registerHelper 'loggedInUserUsername', ->
  Meteor.user()?.username

Template.registerHelper 'unreadMessagesCount', ->
  Counts.get('unreadMessagesCount')

Template.registerHelper 'isMessagesPage', ->
  Router.current().route.getName() is 'messages'

Template.registerHelper 'isNotUndefined', (val) ->
  typeof val != 'undefined'

Template.registerHelper 'trimEmail', (val) ->
  return val.replace(/@.+/, '')

Template.registerHelper 'linkify', (text) ->
  return new Spacebars.SafeString linkify(text || '')

Template.registerHelper 'formatDate', (timestamp) ->
  date = new Date(timestamp)
  date.toDateString() + ' ' + date.toLocaleTimeString()

Template.registerHelper 'getExerciseTitle', (lesson, exerciseId) ->
  lesson.exercises[exerciseId].title

Template.registerHelper 'isOnline', (userId) ->
  Meteor.users.findOne(userId)?.status?.online

Template.registerHelper 'equals', (param1, param2) ->
  return param1 is param2
