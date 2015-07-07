window.onscroll = (e) ->
  #only for tablet & desktop
  if window.innerWidth > 767
    offsetTop = $('.nav-tabs-theory-assignment').offset()?.top
    $el = $('#editor-wrapper, #result-wrapper')
    $editorWrapper = $('#editor-wrapper')
    $resultWrapper = $('#result-wrapper')
    if window.pageYOffset > offsetTop
      $el.addClass('fixed-top')
      $editorWrapper.width($editorWrapper.parent().width())
      $resultWrapper.width($resultWrapper.parent().width())
    else
      $el.removeClass('fixed-top')
      $editorWrapper.width($editorWrapper.parent().width())
      $resultWrapper.width($resultWrapper.parent().width())

window.addEventListener('resize', ->
  $editorWrapper = $('#editor-wrapper')
  $resultWrapper = $('#result-wrapper')
  $editorWrapper.width($editorWrapper.parent().width())
  $resultWrapper.width($resultWrapper.parent().width())
)

document.write = () ->
  output = '';
  i = 0
  while i < arguments.length
    output += "#{arguments[i]} "
    i++
  output += '<br>';
  $('.output').append(output);

loadCode = (href) ->
  currentLesson = LessonsList.getLesson(Session.get('lessonNumber'))
  exercise = LessonsList.getFirstExercise(Session.get('lessonNumber'))
  if Session.get('exerciseId')
    exercise = Lesson.getUserExercise(currentLesson, Session.get('exerciseId'))
  Session.set('activeTab', href.replace('#', ''))
  if (href == '#assignment' or href == 'assignment') and
    Session.get('assignmentCodeLoaded') != currentLesson.id
      lessons = LessonsList.getLessons()
      Lesson.initAssignment(Session.get('lessonNumber'), lessons, ace.edit('editor'))
      Session.set('assignmentCodeLoaded', currentLesson.id)
      Session.set('exerciseCodeLoaded', null)
      Session.set('exerciseSuccess', false)

  if (href == '#exercise' or href == 'exercise') and exercise
    #expand exercise
    $("a.collapsed[href='##{exercise.id}']").trigger('click')

  if (href == '#exercise' or href == 'exercise') and
    Session.get('exerciseCodeLoaded') != exercise?.id and
    exercise
      Lesson.initExercise(currentLesson, exercise, ace.edit('editor'))
      Session.set('exerciseCodeLoaded', exercise?.id)
      Session.set('assignmentCodeLoaded', null)
      Session.set('lessonSuccess', false)

Template.lessonLayout.onRendered (tpl) ->
  Editor.highlightOutput()
  lessons = LessonsList.getLessons()
  Lesson.setLesson(Session.get('lessonNumber'), lessons, editor = ace.edit('editor'))
  if window.scrollY > 280
    $('html, body').animate({
      scrollTop: $("#lesson-title").offset().top
    }, 300);
  #switch tab ("continue to assignment" button)
  $('body').on('shown.bs.tab', 'a[data-toggle="tab"]', (e) ->
    target = this.href.split('#');
    $('html, body').animate({
      scrollTop: $("#lesson-title").offset().top
    }, 300);
    $('.nav a').filter('[href="#'+target[1]+'"]').tab('show')
    loadCode(target[1])
  )
  $('body').on('click', '.nav-tabs a', (e) ->
    e.preventDefault()
    $(this).tab('show')
    currentLesson = LessonsList.getLesson(Session.get('lessonNumber'))
    loadCode(@getAttribute('href'))
  )

Template.lessonLayout.helpers
  config: ->
    return (editor) ->
      # Set some reasonable options on the editor
      editor.setTheme('ace/theme/monokai')
      if Lesson.isJSLesson() or Lesson.isProgrammingChallengeLesson()
        editor.getSession().setMode('ace/mode/javascript')
      else
        editor.getSession().setMode('ace/mode/html')
      editor.setShowPrintMargin(false)
      editor.getSession().setUseWrapMode(true)
      editor.getSession().setTabSize(2);
      lessons = LessonsList.getLessons()
      Lesson.setLesson(Session.get('lessonNumber'), lessons, editor)
  student: ->
    Meteor.users.findOne({ username: Router.current().params.username })
  needHelpList: ->
    NeedHelp.find()
  needHelpNotificationCount: (needHelpId) ->
    App.getUnreadNeedHelpUserCommentsCount(needHelpId, Meteor.userId())
  isInAnotherUserLesson: ->
    Meteor.user() &&
      Router.current().params.username != Meteor.user().username
  activeTabName: ->
    exerciseId = Session.get('exerciseId')
    if Session.get('activeTab') is 'exercise' and exerciseId
      exerciseNumber = exerciseId[exerciseId.length - 1]
      return "#{Session.get('activeTab')} #{exerciseNumber}"
    Session.get('activeTab')
  activeTab: (tabName) ->
    if Session.get('activeTab') == tabName then "active" else ""
  currentUserId: ->
    App.getCurrentUserId()
  isFirstLesson: ->
    Session.get("lessonNumber") is 1
  lessonSuccess: ->
    Session.get('lessonSuccess')
  exerciseSuccess: ->
    Session.get('exerciseSuccess')
  successMsg: ->
    Session.get('successMsg')
  lesson: ->
    LessonsList.getLesson(Session.get("lessonNumber"))
  exercises: ->
    exercises = []
    for key, val of LessonsList.getLesson(Session.get("lessonNumber")).exercises
      exercises.push(val)
    return exercises
  previousLesson: ->
    LessonsList.getLesson(Session.get("lessonNumber") - 1)
  nextLesson: ->
    LessonsList.getLesson(Session.get("lessonNumber") + 1)
  lessonNumber: ->
    Session.get("lessonNumber")
  userLesson: ->
    lessons = LessonsList.getLessons()
    lesson = lessons[Session.get("lessonNumber") - 1]
    Lesson.getUserLesson(lesson.id)
  showStudent: ->
    student = Meteor.users.findOne({ username: Router.current().params.username })
    student?._id != Meteor.userId()
  getTemplateTheoryName: ->
    lessons = LessonsList.getLessons()
    unless lessons[Session.get("lessonNumber") - 1]?.hasTheory
      return null
    if lessons[Session.get("lessonNumber") - 1]?.template
      lessons[Session.get("lessonNumber") - 1]?.template + 'Theory'
    else
      lessons[Session.get("lessonNumber") - 1]?.title.toLowerCase() + 'Theory'
  getTemplateAssignmentName: ->
    lessons = LessonsList.getLessons()
    if lessons[Session.get("lessonNumber") - 1]?.template
      lessons[Session.get("lessonNumber") - 1]?.template + 'Assignment'
    else
      lessons[Session.get("lessonNumber") - 1]?.title.toLowerCase() + 'Assignment'
  getTemplateExerciseName: ->
    lessons = LessonsList.getLessons()
    unless lessons[Session.get("lessonNumber") - 1]?.hasExercise
      return null
    if lessons[Session.get("lessonNumber") - 1]?.template
      lessons[Session.get("lessonNumber") - 1]?.template + 'Exercise'
    else
      lessons[Session.get("lessonNumber") - 1]?.title.toLowerCase() + 'Exercise'
  hasNextExercise: ->
    lesson = LessonsList.getLesson(Session.get('lessonNumber'))
    nextExerciseId = LessonsList.getNextExerciseId Session.get('exerciseId')
    if lesson.exercises and
      lesson.exercises[nextExerciseId]
        return true

setSuccessMsg = (lessonPoints, lesson, user) ->
  totalPoints = user?.points
  unless Meteor.user()?.lessons?[lesson.id]?.pointsAdded
    totalPoints += lessonPoints
  if totalPoints
    if Lesson.isProgrammingChallengeLesson()
      Session.set 'successMsg',
        """
        Congratluations! The output seems to be correct.
        """
    else
      Session.set 'successMsg',
        """
        #{TAPi18n.__('Congratluations! You have earned <b>%s</b> points!', lessonPoints)}
        #{TAPi18n.__('You have %s points in total', totalPoints)}.
        """
  else
    Session.set('successMsg', TAPi18n.__('Correct!'))

setExerciseSuccessMsg = (lesson, exercise) ->
  totalPoints = Meteor.user()?.points
  unless Meteor.user()?.lessons?[lesson.id]?.exercises?[exercise.id]?.pointsAdded
    totalPoints += 2
  if totalPoints
    Session.set 'successMsg',
      """
      #{TAPi18n.__('Congratluations! You have earned <b>2</b> points!')}
      #{TAPi18n.__('You have %s points in total', totalPoints)}.
      #{TAPi18n.__('Do another exercise or go to assignment')}.
      """
  else
    Session.set('successMsg', TAPi18n.__('Correct!'))

Template.lessonLayout.events
  'click .done-btn': ->
    codeError = false
    try
      editor = Editor.getEditor()
      code = editor.getValue()
      #evaluate can throw exception
      Editor.evaluate() if Lesson.isJSLesson() or Lesson.isProgrammingChallengeLesson()
      if Lesson.isHTMLLesson() or Lesson.isCSSLesson()
        $('.output').html(code)
    catch e
      if LessonsList.getCurrentLesson().id != '1x'
        codeError = true
      $('.output').html('Error: ' + e.message)

    lesson = LessonsList.getLesson(Session.get('lessonNumber'))
    lessonNum = Session.get('lessonNumber')

    isAssignmentTab = $('.nav-tabs-theory-assignment .active a').attr('href') == '#assignment'

    #check exercise only if assignment tab is active
    if isAssignmentTab and !codeError

      result = Lesson.checkAssignment
        lessonNumber: lessonNum
        lesson: lesson
        code: code

      ###
      # Save lesson always if user is logged in
      ###
      username = App.getCurrentUsername()
      lessonToSave = {}
      lessonToSave.type = Lesson.getType()
      lessonToSave.number = parseInt lessonNum
      lessonToSave.id = lesson.id
      lessonToSave.code = code
      lessonToSave.slug = lesson.slug
      lessonToSave.success = (if result == true then true else false)
      if Meteor.user() and Meteor.user()?.username is username
        Meteor.call 'saveUserLesson', username, lessonToSave, (err, result) ->
          console.log(err) if err
          console.log('result', result)

      if result == true
        lessonPoints = Lesson.getLessonPoints(Session.get('lessonNumber'), Lesson.getType())
        user = Meteor.user()

        if user
          setSuccessMsg(lessonPoints, lesson, user)
        else
          Session.set('successMsg',
            """
            #{TAPi18n.__('Congratluations! You can continue to the next lesson') + '.'}
            #{TAPi18n.__('But your progress is not saved because you are not logged in') + '.'}
            #{TAPi18n.__('We recommend you to create an account and log in') + '.'}
            """
          )

        Session.set('lessonSuccess', true)
        $('.output-error-text').addClass('hidden');

    isExerciseTab = $('.nav-tabs-theory-assignment .active a').attr('href') == '#exercise'
    if isExerciseTab and !codeError
      result = JSExercise.checkExercise(
        lessonNumber: lessonNum
        lesson: lesson
        exercise: lesson.exercises[Session.get('exerciseId')]
        code: code
      )
      console.log result

      ###
      # Save exercise always if user is logged in
      ###
      userId = App.getCurrentUserId()
      lessonToSave = {}
      lessonToSave.number = parseInt lessonNum
      lessonToSave.id = lesson.id

      exercise = lesson.exercises?[Session.get('exerciseId')]
      exerciseToSave = {}
      exerciseToSave.id = exercise.id
      exerciseToSave.success = (if result == true then true else false)
      exerciseToSave.code = code
      if userId
        Meteor.call 'saveUserJSExercise', userId, lessonToSave, exerciseToSave, (err, result) ->
          console.log(err) if err
          console.log('result', result)

      if result == true
        user = Meteor.user()

        setExerciseSuccessMsg(lesson, exercise)

        Session.set('exerciseSuccess', true)
        $('.output-error-text').addClass('hidden');

    if typeof result is 'string'
      result += '.<br/><br/>Check if your code is written according to conventions.'
      $('.output-error-text').removeClass('hidden').html(TAPi18n.__('Error') + ':\n' + result)


  'click .next-exercise': (e, tpl) ->
    e.preventDefault()
    nextExerciseId = LessonsList.getNextExerciseId Session.get('exerciseId')
    $(tpl.find("#accordion a[href='##{nextExerciseId}']")).trigger('click')
  'submit #bug-form': (e) ->
    e.preventDefault()
    return 0 unless confirm('Do you really want to send bug report?')
    msg = ''
    if Session.get('activeTab') is 'exercise'
      msg += "<p><b>Exercise #{LessonsList.getCurrentExerciseNumber()}:</b></p>"
    if Session.get('activeTab') is 'assignment'
      msg += "<p><b>Assignment:</b></p>"
    msg += "<p>#{e.target.bugreportMsg.value}</p>"

    url = App.getCurrentUrl()

    Meteor.call 'sendBugReport', msg, url, Editor.getValue(), (err, result) ->
      if err
        console.log err
        bootbox.alert(err.message)
      else
        e.target.bugreportMsg.value = ''
        bootbox.alert(TAPi18n.__ 'Bugreport sent. Thank you!')
