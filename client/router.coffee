Router.onBeforeAction(->
  unless Meteor.userId()
    Router.go('main')
  @next()
, {
  only: [ 'messages', 'userSettings' ]
})

Router.onBeforeAction ->
    if Meteor.user() and Meteor.user().username?.indexOf('@') != -1
      Router.go('changeUsername')
    @next()
  ,
    #this is important because this onBeforeAction causes problem on lessonJS page
    #it's because js lessons are stored in user object
    except: [ 'lessonJS' ]

Router.route '/:lang?/change-username',
  name: 'changeUsername'
  onAfterAction: ->
    App.setPageTitle('Change username')

Router.route '/:lang?/javascript/lesson/:_id/:slug/:username?',
  name: 'lessonJS'
  layoutTemplate: 'lessonLayout'
  yieldTemplates:
    'JSLevelsMenu': { to: 'levelsMenu' }
  onBeforeAction: ->
    Session.set('lessonSuccess', false)
    Session.set('exerciseSuccess', false)
    lesson = JSLessonsList._collection.findOne({ id: @params._id })
    if lesson
      Session.set('levelNumber', Lesson.getJSLevelNum(lesson.num))
      Session.set('lessonNumber', lesson.num)
      exercise = JSLessonsList.getFirstExercise(lesson.num)
      Session.set('exerciseId', exercise?.id)
      if lesson.hasTheory
        Session.set('activeTab', 'theory')
    else
      Session.set('lessonNumber', 1)
    @next()
  subscriptions: ->
    @subscribe('needHelpForLessonAndUser', @params._id, @params.username)
    if @params.username
      @subscribe 'student', @params.username, ->
        lessons = JSLessonsList.getLessons()
        #lesson result depends on user so set lesson again on ready subscription
        Lesson.setLesson(Session.get('lessonNumber'), lessons, ace.edit('editor'))
  onAfterAction: ->
    lessons = JSLessonsList.getLessons()
    lesson = JSLessonsList._collection.findOne({ id: @params._id })
    if lesson
      App.setPageTitle('JavaScript ' + lesson.title)
    Meteor.setTimeout ->
      hash = window.location.hash
      if hash
        $("a[href=#exercise]").trigger('click')
        unless $(hash).is(':visible')
          $("a[href='#{hash}']").trigger('click')
    , 50
    if document.getElementById('editor')
      $('.output').html("&larr; #{TAPi18n.__('Press submit')}")
      $('.output-error-text').addClass('hidden');
      Meteor.setTimeout ->
        Lesson.setLesson(Session.get('lessonNumber'), lessons, ace.edit('editor'))
      , 100
  data: ->
    lessonType: 'javascript'

Router.route '/:lang?/html/lesson/:_id/:slug/:username?',
  name: 'lessonHTML'
  layoutTemplate: 'lessonLayout'
  yieldTemplates:
    'HTMLLevelsMenu': { to: 'levelsMenu' }
  onBeforeAction: ->
    Session.set('lessonSuccess', false)
    Session.set('exerciseSuccess', false)
    lesson = HTMLLessonsList._collection.findOne({ id: @params._id })
    if lesson
      Session.set('levelNumber', HTMLLessonsList.getLevelNum(lesson.num))
      Session.set('lessonNumber', lesson.num)
      if lesson.hasTheory
        Session.set('activeTab', 'theory')
    else
      Session.set('lessonNumber', 1)
    @next()
  subscriptions: ->
    @subscribe 'needHelpForLessonAndUser',
      lessonId: @params._id
      lessonType: 'html'
      username: @params.username
    if @params.username
      @subscribe 'studentLessonData', @params.username
      @subscribe 'userHTMLLessons', { username: @params.username, lessonId: @params._id }, ->
        lessons = HTMLLessonsList.getLessons()
        console.log 'userHtmlLessons num:', Session.get('lessonNumber')
        #lesson result depends on user so set lesson again on ready subscription
        Lesson.setLesson(Session.get('lessonNumber'), lessons, ace.edit('editor'))
  onAfterAction: ->
    lesson = HTMLLessonsList._collection.findOne({ id: @params._id })
    if lesson
      App.setPageTitle('HTML ' + lesson.title)
  data: ->
    lessonType: 'html'

Router.route '/:lang?/css/lesson/:_id/:slug/:username?',
  name: 'lessonCSS'
  layoutTemplate: 'lessonLayout'
  yieldTemplates:
    'CSSLevelsMenu': { to: 'levelsMenu' }
  onBeforeAction: ->
    App.currentRouteLessons = 'css'
    Session.set('lessonSuccess', false)
    Session.set('exerciseSuccess', false)
    Session.set('activeTab', 'theory')
    lesson = CSSLessonsList._collection.findOne({ id: @params._id })
    if lesson
      Session.set('levelNumber', CSSLessonsList.getLevelNum(lesson.num))
      Session.set('lessonNumber', lesson.num)
      if lesson.hasTheory
        Session.set('activeTab', 'theory')
    else
      Session.set('lessonNumber', 1)
    @next()
  subscriptions: ->
    @subscribe 'needHelpForLessonAndUser',
      lessonId: @params._id
      lessonType: 'css'
      username: @params.username
    if @params.username
      @subscribe 'studentLessonData', @params.username
      @subscribe 'userCSSLessons', { username: @params.username, lessonId: @params._id }, ->
        lessons = CSSLessonsList.getLessons()
        #lesson result depends on user so set lesson again on ready subscription
        Lesson.setLesson(Session.get('lessonNumber'), lessons, ace.edit('editor'))
  onAfterAction: ->
    lesson = CSSLessonsList._collection.findOne({ id: @params._id })
    if lesson
      App.setPageTitle('CSS ' + lesson.title)
  data: ->
    lessonType: 'css'

Router.route '/:lang?/programming-challenge/lesson/:_id/:slug/:username?',
  name: 'lessonProgrammingChallenge'
  layoutTemplate: 'lessonLayout'
  yieldTemplates:
    'programmingChallengeLevelsMenu': { to: 'levelsMenu' }
  onBeforeAction: ->
    Session.set('lessonSuccess', false)
    Session.set('exerciseSuccess', false)
    Session.set('activeTab', 'assignment')
    lesson = ProgrammingChallengeLessonsList._collection.findOne({ id: @params._id })
    if lesson
      Session.set('levelNumber', ProgrammingChallengeLessonsList.getLevelNum(lesson.num))
      Session.set('lessonNumber', lesson.num)
    else
      Session.set('lessonNumber', 1)
    @next()
  subscriptions: ->
    if @params.username
      @subscribe 'studentLessonData', @params.username
      @subscribe 'userProgrammingChallengeLessons',
        lessonId: @params._id
        username: @params.username
      , ->
        lessons = ProgrammingChallengeLessonsList.getLessons()
        #lesson result depends on user so set lesson again on ready subscription
        Lesson.setLesson(Session.get('lessonNumber'), lessons, ace.edit('editor'))
  onAfterAction: ->
    lesson = ProgrammingChallengeLessonsList._collection.findOne({ id: @params._id })
    if lesson
      App.setPageTitle(lesson.title)
  data: ->
    lessonType: 'programming-challenge'

Router.route '/:lang?/web-developer/lesson/:_id/:slug/:username?',
  name: 'lessonWebDeveloper'
  layoutTemplate: 'lessonLayout'
  yieldTemplates:
    'webDeveloperLevelsMenu': { to: 'levelsMenu' }
  onBeforeAction: ->
    Session.set('lessonSuccess', false)
    Session.set('exerciseSuccess', false)
    lesson = WebDeveloperLessonsList._collection.findOne({ id: @params._id })
    if lesson
      Session.set('levelNumber', WebDeveloperLessonsList.getLevelNum(lesson.num))
      Session.set('lessonNumber', lesson.num)
    else
      Session.set('lessonNumber', 1)
    @next()
  data: ->
    lessonType: 'web-developer'

#this route needs to be defined after other lesson routes
Router.route '/:lang?/:lessonType/lesson/:_id/:slug/:username?',
  name: 'lesson'
  layoutTemplate: 'lessonLayout'
  onBeforeAction: ->
    console.log 'onBeforeAction lesson'
    #TODO page not found if lesson type is not correct
    templateName = 'lessonJS' #default is lessonJS
    if @params.lessonType is 'html'
      templateName = 'lessonHTML'
    if @params.lessonType is 'css'
      templateName = 'lessonCSS'
    Router.go templateName,
      _id: @params._id
      slug: @params.slug
      username: @params.username

Router.route '/:lang?/ultimate-guide-for-web-developer',
  name: 'guide'
  onAfterAction: ->
    App.setPageTitle('Ultimate guide for web developer')

Router.route '/:lang?/help',
  name: 'help'
  waitOn: ->
    #subscribe to not solved needHelp
    solved = false
    Meteor.subscribe('needHelp', '', solved)
  onAfterAction: ->
    App.setPageTitle('Help')
  data: ->
    needHelp: NeedHelp.find({}, { sort: { timestamp: -1 }, reactive: false })

Router.route '/:lang?/help/:id',
  name: 'helpDetail'
  waitOn: ->
    Meteor.subscribe('needHelp', @params.id)
  onAfterAction: ->
    App.setPageTitle('Help')
    Meteor.call 'setNeedHelpCommentsRead', @params.id if Meteor.userId()
  data: ->
    needHelp: NeedHelp.findOne()

Router.route '/:lang?/leaderboard',
  name: 'leaderboard'
  waitOn: ->
    [
      Meteor.subscribe('studentsList')
      Meteor.subscribe('studentsCount')
    ]
  data: ->
    students: Meteor.users.find({ 'roles.all': 'student'}, { sort: { points: -1 } })
    restStudentsCount: if (Counts.get('studentsCount') - 250 > 0) then Counts.get('studentsCount') - 250 else 0
  onAfterAction: ->
    App.setPageTitle('Leaderboard')

Router.route '/:lang?/students',
  name: 'students'
  waitOn: ->
    Meteor.subscribe('studentsList')
  data: ->
    students: Meteor.users.find({ 'roles.all': 'student'})
  onAfterAction: ->
    App.setPageTitle('Students')

Router.route '/:lang?/students/:username/',
  name: 'studentProfile'
  waitOn: ->
    [
      Meteor.subscribe('student', @params.username)
      Meteor.subscribe('userStudyGroups', @params.username)
    ]
  data: ->
    student: Meteor.users.findOne({ username: @params.username })
  onAfterAction: ->
    App.setPageTitle(@params.username)

Router.route '/:lang?/user/settings',
  name: 'userSettings'
  waitOn: ->
    Meteor.subscribe('userSettings')
  data: ->
    userSettings: Meteor.users.findOne()?.settings
  onAfterAction: ->
    App.setPageTitle('User settings')

Router.route '/:lang?/study-groups',
  name: 'studyGroups'
  waitOn: ->
    Meteor.subscribe('studyGroups')
  onAfterAction: ->
    App.setPageTitle("Study groups")
  data: ->
    studyGroups: StudyGroups.find({}, { sort: { timestamp: 1 }})

Router.route '/:lang?/study-groups/:_id',
  name: 'studyGroup'
  waitOn: ->
    Meteor.subscribe('studyGroups', 5)
    Meteor.subscribe('studyGroup', @params._id)
  onAfterAction: ->
    studyGroup = StudyGroups.findOne(@params._id)
    App.setPageTitle("#{studyGroup?.title} - study group")
  data: ->
    studyGroup: StudyGroups.findOne(@params._id)
    studyGroups: StudyGroups.find({}, { sort: { timestamp: 1 }})

Router.route '/:lang?/study-groups/:studyGroupId/homework/:homeworkId/:username?',
  name: 'studyGroupHomework'
  waitOn: ->
    [
      Meteor.subscribe('studyGroup', @params.studyGroupId)
      Meteor.subscribe('homework', { studyGroupId: @params.studyGroupId })
    ]
  data: ->
    homeworkList: Homework.find()
    homework: Homework.findOne @params.homeworkId
    studyGroup: StudyGroups.findOne @params.studyGroupId
  onAfterAction: ->
    App.setPageTitle('Study group homework')

Router.route '/:lang?/messages/:username?',
  name: 'messages'
  onBeforeAction: ->
    if Roles.userIsInRole(Meteor.userId(), 'student', 'all') and
      !@params.username
        @redirect('messages', { username: 'elfoslav' })
    @next()
  subscriptions: ->
    if @params.username and Meteor.user()?.username
      @subscribe('messages', {
        receiverUsername: @params.username
        senderUsername: Meteor.user()?.username
      }).wait()
    @subscribe('sendersList').wait()
    @subscribe('usernames', '')
  data: ->
    return {
      messages:
        Messages.find({
          $or: [
            {
              $and: [
                { senderUsername: @params.username }
                { receiverUsername: Meteor.user()?.username }
              ]
            }
            {
              $and: [
                { senderUsername: Meteor.user()?.username }
                { receiverUsername: @params.username }
              ]
            }
          ]
        }, {
          sort:
            timestamp: -1
        })
    }
  onAfterAction: ->
    if @params.username
      Meteor.call('markMessagesAsRead', @params.username) if Meteor.userId()
      App.setPageTitle("#{@params.username} messages")
    else
      App.setPageTitle("Messages")

Router.route '/:lang?/knowledge-base',
  name: 'knowledgeBase'
  onAfterAction: ->
    App.setPageTitle('Knowledge Base')

Router.route '/:lang?/knowledge-base/front-end-developer',
  name: 'knowledgeBaseFrontEndDeveloper'
  onAfterAction: ->
    App.setPageTitle('Knowledge Base - Frontend Developer')

Router.route '/:lang?/knowledge-base/back-end-developer',
  name: 'knowledgeBaseBackEndDeveloper'
  onAfterAction: ->
    App.setPageTitle('Knowledge Base - Back Developer')

Router.route '/:lang?/knowledge-base/full-stack-developer',
  name: 'knowledgeBaseFullStackDeveloper'
  onAfterAction: ->
    App.setPageTitle('Knowledge Base - Full-stack Developer')

######
# BLOG
######
Router.route '/:lang?/blog',
  name: 'blog'
  onAfterAction: ->
    App.setPageTitle('Blog')

Router.route '/:lang?/blog/how-to-learn-to-code-properly',
  name: 'howToLearnToCodeProperly'
  layoutTemplate: 'blogLayout'
  data: ->
    title: 'How to learn to code properly'
    date: '30th March 2015'
  onAfterAction: ->
    App.setPageTitle('How to learn to code properly')

Router.route '/:lang?/blog/introducing-study-groups',
  name: 'introducingStudyGroups'
  layoutTemplate: 'blogLayout'
  data: ->
    title: 'Introducing study groups'
    date: '24th May 2015'
  onAfterAction: ->
    App.setPageTitle('Why CoderMania?')

Router.route '/:lang?/blog/why-codermania',
  name: 'whyCoderMania'
  layoutTemplate: 'blogLayout'
  data: ->
    title: 'Why Codermania?'
    date: '28th March 2015'
  onAfterAction: ->
    App.setPageTitle('Why CoderMania?')

Router.route '/:lang?/blog/why-javascript',
  name: 'whyJavaScript'
  layoutTemplate: 'blogLayout'
  data: ->
    title: 'Why JavaScript?'
    date: '26th March 2015'
  onAfterAction: ->
    App.setPageTitle('Why JavaScript?')

Router.route '/:lang?/blog/why-learn-to-code',
  name: 'whyLearnToCode'
  layoutTemplate: 'blogLayout'
  data: ->
    title: 'Why learn to code?'
    date: '24th March 2015'
  onAfterAction: ->
    App.setPageTitle('Why learn to code?')

Router.route '/:lang?/contact',
  name: 'contact'
  onAfterAction: ->
    App.setPageTitle('Contact')

Router.route '/:lang?/presentation',
  name: 'presentation'
  waitOn: ->
    Meteor.subscribe('slides', @params.lang || 'sk')
  onAfterAction: ->
    App.setPageTitle('Presentation')

#routes for courses in Slovak language
Router.route '/:lang?/kurzy',
  name: 'SKCourses'
  onAfterAction: ->
    App.setPageTitle('Programátorské kurzy')

Router.route '/:lang?/kurzy/zaklady-programovania',
  name: 'basicProgramming'
  layoutTemplate: 'SKCourseLayout'
  onAfterAction: ->
    App.setPageTitle('Kurzy - Základy programovania')

Router.route '/:lang?/kurzy/tvorba-webovych-stranok',
  name: 'webPages'
  layoutTemplate: 'SKCourseLayout'
  onAfterAction: ->
    App.setPageTitle('Kurzy - Tvorba webových stránok')

Router.route '/:lang?/kurzy/tvorba-webovych-aplikacii',
  name: 'webApplications'
  layoutTemplate: 'SKCourseLayout'
  onAfterAction: ->
    App.setPageTitle('Kurzy - Tvorba webových aplikácií')

Router.route '/:lang?/kurzy/full-stack-web-developer',
  name: 'fullstackWebDeveloper'
  layoutTemplate: 'SKCourseLayout'
  onAfterAction: ->
    App.setPageTitle('Kurzy - Full-stack Web Developer')

Router.route '/:lang?/kurzy/letna-web-developerska-skola',
  name: 'summerWebDevelopmentSchool'
  layoutTemplate: 'SKCourseLayout'
  onBeforeAction: ->
    TAPi18n.setLanguage('sk')
    @next()
  waitOn: ->
    Meteor.subscribe 'summerWebDevSchoolStudyGroups'
  onAfterAction: ->
    App.setPageTitle('Kurzy - Letná web developerská škola')
  data: ->
    studyGroup: StudyGroups.findOne({ title: 'Letná web developerská škola 2015' })
    onlineStudyGroup: StudyGroups.findOne({ title: 'Online letná web developerská škola 2015' })

Router.route '/:lang?/courses/web-development-school',
  name: 'webDevelopmentSchool'
  layoutTemplate: 'ENCourseLayout'
  onBeforeAction: ->
    TAPi18n.setLanguage('en')
    @next()
  waitOn: ->
    Meteor.subscribe 'summerWebDevSchoolStudyGroups', 'en'
  onAfterAction: ->
    App.setPageTitle('Web development school')
  data: ->
    studyGroup: StudyGroups.findOne({ title: 'Web development school 2015' })

#realtime code used for meteor workshop
Router.route '/:lang?/code',
  name: 'code'
  waitOn: ->
    Meteor.subscribe 'code'
  onAfterAction: ->
    App.setPageTitle('Realtime code')

#main route has to be last because of lang parameter
Router.route '/:lang?/',
  name: 'main'
  waitOn: ->
    Meteor.subscribe 'homepageStudyGroups'
  onAfterAction: ->
    App.setPageTitle('Learn to code')
  data: ->
    homepageStudyGroups: StudyGroups.find({}, { sort: { timestamp: 1 }})

Router.onBeforeAction ->
  if @params.lang
    TAPi18n.setLanguage(@params.lang)
  @next()

Router.onAfterAction ->
  if location.origin != 'http://localhost:3000'
    ga('send', 'pageview', Router.current().location.get().path)

Router.configure
  layoutTemplate: 'layout'
  trackPageView: true
