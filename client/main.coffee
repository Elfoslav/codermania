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

Template.layout.rendered = ->
  console.log 'layout rendered'

Handlebars.registerHelper 'arrayify', (obj) ->
  result = []
  for key, value of obj
    result.push({ key:key,value: value })
  return result

Handlebars.registerHelper 'lesson', (id) ->
  lesson = LessonsList._collection.findOne({ id: id })
  return lesson if lesson
  lesson = LessonsList._collection.findOne({ id: @key })
  return lesson

Handlebars.registerHelper 'lessonTitle', (id) ->
  return LessonsList._collection.findOne({ id: id })?.title

Handlebars.registerHelper 'lessonId', ->
  lessons = LessonsList.getLessons()
  return lessons[Session.get('lessonNumber')]?.id

Handlebars.registerHelper 'lessonSlug', ->
  lessons = LessonsList.getLessons()
  return lessons[Session.get('lessonNumber')]?.slug

Handlebars.registerHelper 'lang', (id) ->
  lang = TAPi18n.getLanguage()
  return if (lang == 'en') then '' else lang

Handlebars.registerHelper 'userId', ->
  Meteor.userId() || undefined

Handlebars.registerHelper 'username', ->
  App.getCurrentUsername()

Handlebars.registerHelper 'loggedInUserUsername', ->
  Meteor.user()?.username

Handlebars.registerHelper 'unreadMessagesCount', ->
  if Router.current().route.getName() is 'messages'
    return 0
  Counts.get('unreadMessagesCount')

Handlebars.registerHelper 'isNotUndefined', (val) ->
  typeof val != 'undefined'

Handlebars.registerHelper 'trimEmail', (val) ->
  return val.replace(/@.+/, '')

Handlebars.registerHelper 'linkify', (text) ->
  return new Spacebars.SafeString linkify(text)

Handlebars.registerHelper 'formatDate', (timestamp) ->
  date = new Date(timestamp)
  date.toDateString() + ' ' + date.toLocaleTimeString()

Handlebars.registerHelper 'getExerciseTitle', (lesson, exerciseId) ->
  lesson.exercises[exerciseId].title

Handlebars.registerHelper 'isOnline', (userId) ->
  Meteor.users.findOne(userId)?.status?.online
