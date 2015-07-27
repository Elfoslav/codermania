Meteor.methods
  saveUserLesson: (username, lesson) ->
    check username, String
    check lesson,
      id: String
      type: String #javascript|html|css|programming-challenge
      title: String
      slug: String
      number: Number
      code: String
      success: Boolean

    user = Meteor.users.findOne({ username: username })
    unless user?._id == @userId
      throw new Meteor.Error(401, 'Access denied')

    lessonPoints = Lesson.getLessonPoints(lesson.number, lesson.type)

    qry = {}
    #this if is from historical reason
    #we used JS lessons in user collection before
    if lesson.type is 'javascript'
      qry["lessons.#{lesson.id}.id"] = lesson.id
      qry["lessons.#{lesson.id}.code"] = lesson.code
      qry["lessons.#{lesson.id}.success"] = lesson.success
      qry["lessons.#{lesson.id}.date"] = new Date()
      qry["lessons.#{lesson.id}.timestamp"] = new Date().getTime()
      qry["lessons.#{lesson.id}.changedBy"] = @userId
      qry["lessons.#{lesson.id}.points"] = lessonPoints
    else
      lesson.date = new Date()
      lesson.timestamp = Date.now()
      lesson.changedBy = @userId
      lesson.points = lessonPoints

    if lesson.type is 'javascript'
      userLesson = user?.lessons?[lesson.id]
      qry["lessons.#{lesson.id}.pointsAdded"] = userLesson?.pointsAdded
    else if lesson.type is 'html'
      userLesson = UserHTMLLessons.findOne
        id: lesson.id
        userId: @userId
      lesson.pointsAdded = userLesson?.pointsAdded
    else if lesson.type is 'css'
      userLesson = UserHTMLLessons.findOne
        id: lesson.id
        userId: @userId
      lesson.pointsAdded = userLesson?.pointsAdded
    else if lesson.type is 'programming-challenge'
      userLesson = UserProgrammingChallengeLessons.findOne
        id: lesson.id
        userId: @userId
      lesson.pointsAdded = userLesson?.pointsAdded
    else
      throw new Meteor.Error 'Unknown lesson type', 'Unknown lesson type: ' + lesson.type

    #variable used in catch to rollback possibly added user points
    pointsAdded = false
    try
      username = user.username.replace(' ', '%20')
      programmingChallengeUrl = "#{Meteor.absoluteUrl()}programming-challenge/lesson/#{lesson.id}/#{lesson.slug}/#{username}"
      elfoslav = Meteor.users.findOne({ username: 'elfoslav' })
      #add points before updating user
      if lesson.success
        if (userLesson is undefined) or !userLesson?.pointsAdded
          Meteor.users.update(user._id, {
            $inc: { points: lessonPoints }
          })
          #send message only for the first correct submission
          if user._id != elfoslav._id and lesson.type is 'programming-challenge'
            App.insertMessage
              senderId: user._id
              senderUsername: user.username
              receiverId: elfoslav._id
              receiverUsername: elfoslav.username
              text: """
                I have finished programming challenge lesson
                #{programmingChallengeUrl}
              """
          pointsAdded = true
          if lesson.type is 'javascript'
            qry["lessons.#{lesson.id}.pointsAdded"] = true
          else
            lesson.pointsAdded = true

        needHelpSolved = true

      needHelpQry =
        lessonId: lesson.id
        username: user.username
        exerciseId: null
      #there was not lesson type for javascript need help
      unless lesson.type is 'javascript'
        needHelpQry.type = lesson.type
      NeedHelp.update needHelpQry,
        $set:
          lessonCode: lesson.code
          solved: needHelpSolved

      if user._id == @userId
        qry["lastLesson"] = lesson
      Meteor.users.update(user._id, {
        $set: qry
      })

      if lesson.type is 'html'
        return UserHTMLLessons.upsert
          userId: @userId
          id: lesson.id
        ,
          $set: lesson

      if lesson.type is 'css'
        return UserCSSLessons.upsert
          userId: @userId
          id: lesson.id
        ,
          $set: lesson

      if lesson.type is 'programming-challenge'
        UserProgrammingChallengeLessons.upsert
          userId: @userId
          id: lesson.id
        ,
          $set: lesson

        if lesson.success and user._id != elfoslav._id
          App.notifyTeachers
            userId: @userId
            sourceId: lesson.type + lesson.id
            type: 'Programming challenge'
            text: "
              User
              <a href='#{Meteor.absoluteUrl()}students/#{Meteor.user()?.username}'>#{Meteor.user()?.username}</a>
              finished programming challenge
              <a class='notification-source-link' href='#{programmingChallengeUrl}'>#{lesson.title}</a>.
            "
    catch err
      @unblock()
      Logger.log err.message, 'error', 'saveUserLesson method'
      if pointsAdded
        Meteor.users.update user._id,
          $dec: { points: lessonPoints }
      throw new Meteor.Error '', err.message

  saveUserJSExercise: (userId, lesson, exercise) ->
    check(userId, String)
    check(lesson, {
      id: String
      number: Number
    })
    check(exercise, {
      id: String
      code: String
      success: Boolean
    })

    unless userId == @userId
      throw new Meteor.Error(401, 'Access denied')

    points = 2 #get 2 points for each exercise
    exercise.date = new Date()
    exercise.timestamp = new Date().getTime()
    exercise.changedBy = @userId
    exercise.points = points

    user = Meteor.users.findOne(userId)
    userExercise = user?.lessons?[lesson.id]?.exercises?[exercise.id]
    exercise.pointsAdded = userExercise?.pointsAdded

    shouldAddPoints = false
    if exercise.success
      if (userExercise is undefined) or !userExercise.pointsAdded
        shouldAddPoints = true
        exercise.pointsAdded = true
      NeedHelp.update { exerciseId: exercise.id, username: user.username },
        $set: { solved: true }

    NeedHelp.update { exerciseId: exercise.id, username: user.username },
      $set: { lessonCode: exercise.code }

    qry = {}
    qry["lessons.#{lesson.id}.exercises.#{exercise.id}"] = exercise
    Meteor.users.update(userId, {
      $set: qry
    })
    if shouldAddPoints
      Meteor.users.update(userId, {
        $inc: { points: points }
      })

  askForHelp: (lesson, message) ->
    check lesson.url, String
    check lesson.type, String
    check lesson.code, String
    unless @userId
      throw new Meteor.Error('Not authorized')

    @unblock()
    user = Meteor.users.findOne(@userId)
    existingNeedHelp = NeedHelp.findOne
      lessonId: lesson.id
      exerciseId: lesson.exerciseId
      userId: @userId

    if existingNeedHelp
      NeedHelp.update { lessonId: lesson.id, userId: @userId, exerciseId: lesson.exerciseId },
        $set:
          lessonCode: lesson.code
          message: message
          timestamp: Date.now()
          solved: false
          comments: []
    else
      NeedHelp.insert
        lessonId: lesson.id
        exerciseId: lesson.exerciseId
        lessonCode: lesson.code
        lessonType: lesson.type
        lessonUrl: lesson.url
        userId: @userId
        username: user.username
        message: message
        timestamp: Date.now()
        solved: false

    if lesson.exerciseId
      lesson.title += " (#{lesson.exercises?[lesson.exerciseId]?.title})"

    Email.send
      from: user?.emails?[0]?.address
      to: 'tomas@codermania.com'
      subject: "CoderMania - #{user.username} is asking for help"
      html: "Hi,\n I'm asking for help with lesson
        <a href=\"#{lesson.url}\">#{lesson.title}</a>
        <p><b>Message:</b></p>
        <pre>#{message}</pre>"

  sendBugReport: (msg, url, code) ->
    check(msg, String)
    check(url, String)
    check(code, String)

    user = Meteor.users.findOne(@userId)
    if msg
      msg = msg.replace('\n', '<br>')

    if code
      code = "<pre>#{code}</pre>"

    if url
      url = "<a href='#{url}'>#{url}</a>"

    subject = "CoderMania - bugreport"
    if user
      subject += ' from ' + user.username

    @unblock()
    Email.send
      from: user?.emails?[0]?.address || 'bugreport@codermania.com'
      to: 'tomas@codermania.com'
      subject: subject
      html: msg + '<br>' + code + '<br>' + url

  sendMessage: (options) ->
    check(options, {
      username: String #receiver's username
      sendEmail: Boolean
      message: String
    })

    throw new Meteor.Error(401, 'Unauthorized! You have to be logged in to perform this action.') unless @userId

    sender = Meteor.users.findOne(@userId)
    receiver = Meteor.users.findOne({ username: options.username })
    App.insertMessage
      senderId: @userId
      senderUsername: sender.username
      receiverId: receiver._id
      receiverUsername: receiver.username
      text: options.message

    if options.sendEmail and Meteor.isServer
      @unblock()
      App.sendEmailAboutMessage
        sender: sender
        receiver: receiver

  unreadMessagesCount: ->
    receiver = Meteor.users.findOne(@userId)

    Messages.find({
      receiverId: receiver?._id
      isRead: false
    }).count()

  markMessagesAsRead: (senderUsername) ->
    check(senderUsername, String)
    throw new Meteor.Error(401, 'Unauthorized!') unless @userId
    sender = Meteor.users.findOne({username: senderUsername})
    Messages.update { senderId: sender?._id, receiverId: @userId },
      $set:
        isRead: true
    ,
      multi: true

    SendersList.update { senderId: sender?._id, receiverId: @userId },
      $set:
        unreadMsgsCount: 0

  makeReadStudentHomeworkComments: (studentHomeworkId) ->
    check studentHomeworkId, String
    studentHw = StudentHomework.findOne studentHomeworkId
    AppNotifications.update { sourceId: studentHw._id },
      $addToSet: { isReadBy: @userId }
    ,
      multi: true
    if studentHw.userId is @userId
      StudentHomeworkComments.update { studentHomeworkId: studentHomeworkId },
        $set: { isRead: true }
      ,
        multi: true

  getNeedHelpCommentsCounter: (needHelpId) ->
    if needHelpId
      return NeedHelpComments.find
        needHelpId: needHelpId
        userId: $ne: @userId
        readBy: { $nin: [ @userId ]}
      .count()
    return NeedHelpComments.find
      userId: $ne: @userId
      readBy: { $nin: [ @userId ]}
    .count()

  setNeedHelpCommentsRead: (needHelpId) ->
    check needHelpId, String
    throw new Meteor.Error(401, 'Unauthorized!') unless @userId
    allUserCommentsCount = App.getAllNeedHelpUserCommentsCount(needHelpId, @userId)
    readUserCommentsCount = App.getReadNeedHelpUserCommentsCount(needHelpId, @userId)
    if allUserCommentsCount != readUserCommentsCount
      NeedHelpComments.update
          needHelpId: needHelpId
          userId: { $ne: @userId }
          readBy: { $nin: [ @userId ] }
        ,
          $push: readBy: @userId
        ,
          multi: true

  createStudyGroup: (data) ->
    check data,
      title: String
      topics: Match.Optional String
      capacity: Match.Optional Number
      description: Match.Optional String
      isPublic: Boolean
      curriculumId: Match.Optional String

    if !Roles.userIsInRole(@userId, 'teacher', 'all')
      throw new Meteor.Error(401, 'Unauthorized!')

    data.userId = @userId
    data.userIds = [ @userId ]

    existingStudyGroup = StudyGroups.findOne({ userId: @userId, title: data.title })
    if existingStudyGroup
      StudyGroups.update({ userId: @userId, title: data.title }, {
        $set: data
      })
    else
      data.timestamp = Date.now()
      StudyGroups.insert data

  editStudyGroup: (data) ->
    check data,
      _id: String
      title: String
      topics: Match.Optional String
      capacity: Match.Optional Number
      description: Match.Optional String
      isPublic: Boolean
      curriculumId: Match.Optional String

    if !Roles.userIsInRole(@userId, 'teacher', 'all')
      throw new Meteor.Error(401, 'Unauthorized!')

    StudyGroups.update(data._id, {
      $set: data
    })

  markStudyGroupMessagesAsRead: (studyGroupId) ->
    check studyGroupId, String
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    studyGroup = StudyGroups.findOne(studyGroupId)
    unless studyGroup.isAMember(@userId)
      throw new Meteor.Error('not a member',
        "Currently logged in user (#{@userId}) is not a member of the group with id #{studyGroupId}")

    StudyGroupMessages.update
      studyGroupId: studyGroupId
      isReadBy: $nin: [ @userId ]
    ,
      $addToSet: isReadBy: @userId
    ,
      multi: true

  addOrEditCurriculum: (data, studyGroupId) ->
    check data,
      _id: Match.Optional String
      title: String
      text: String
    check studyGroupId, Match.Optional String

    if !Roles.userIsInRole(@userId, 'teacher', 'all')
      throw new Meteor.Error(401, 'Unauthorized!')

    data.createdBy = @userId
    data.timestamp = Date.now()

    if data._id
      id = data._id
      delete data._id
      StudyGroupCurriculums.update(id, { $set: data })
    else
      delete data._id
      curriculumId = StudyGroupCurriculums.insert(data)
      if studyGroupId
        StudyGroups.update studyGroupId, { $set: { curriculumId: curriculumId }}

  saveStudentHomework: (data) ->
    check data,
      studyGroupId: String
      homeworkId: String
      code: String
      submittedAt: Match.Optional Number
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    homework = Homework.findOne data.homeworkId
    data.title = homework?.title
    data.userId = @userId
    data.username = Meteor.user().username
    data.points = homework.points
    data.timestamp = Date.now()

    existingHomework = StudentHomework.findOne
      userId: @userId
      homeworkId: data.homeworkId
    if existingHomework
      StudentHomework.update
        userId: @userId
        homeworkId: data.homeworkId
      ,
        $set:
          title: data.title
          code: data.code
          username: data.username
          updatedAt: Date.now()
          submittedAt: data.submittedAt
    else
      StudentHomework.insert data

  submitStudentHomework: (data) ->
    check data,
      studyGroupId: String
      homeworkId: String
      code: String
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    data.submittedAt = Date.now()
    Meteor.call 'saveStudentHomework', data

    homework = Homework.findOne data.homeworkId
    App.notifyTeachers
      userId: @userId
      sourceId: data.homeworkId
      type: 'Homework'
      text: "
        User
        <a href='#{Meteor.absoluteUrl()}students/#{Meteor.user()?.username}'>#{Meteor.user()?.username}</a>
        finished homework
        <a class='notification-source-link'
          href='#{Meteor.absoluteUrl()}study-groups/#{data.studyGroupId}/homework/#{data.homeworkId}/#{Meteor.user()?.username}'>
            #{homework.title}.
        </a>
      "
  markHomeworkAsCorrect: (data) ->
    check data,
      homeworkId: String
      username: String
    unless Roles.userIsInRole @userId, 'teacher', 'all'
      throw new Meteor.Error 401, 'Unauthorized'
    user = Meteor.users.findOne { username: data.username }
    studentHw = StudentHomework.findOne { homeworkId: data.homeworkId, userId: user?._id }
    unless studentHw
      throw new Meteor.Error 500, "Student's homework does not exist, it's not submitted yet."
    homework = Homework.findOne data.homeworkId
    setData =
      success: true
    if !studentHw?.pointsAdded and homework?.points
      #get points to the user for homework
      Meteor.users.update user._id,
        $inc: { points: homework.points }
      setData.pointsAdded = true
    StudentHomework.update
      homeworkId: data.homeworkId
      userId: user?._id
    ,
      $set: setData

  markHomeworkAsIncorrect: (data) ->
    check data,
      homeworkId: String
      username: String
    unless Roles.userIsInRole @userId, 'teacher', 'all'
      throw new Meteor.Error 401, 'Unauthorized'
    user = Meteor.users.findOne { username: data.username }
    StudentHomework.update
      homeworkId: data.homeworkId
      userId: user?._id
    ,
      $set:
        success: false

  sortStudyGroupHomework: (studyGroupId, homeworkIds) ->
    check studyGroupId, String
    check homeworkIds, Array
    unless Roles.userIsInRole @userId, 'teacher', 'all'
      throw new Meteor.Error 401, 'Unauthorized'
    if homeworkIds.indexOf(null) != -1
      throw new Meteor.Error 500, 'Unable to set homework with ID null'
    StudyGroups.update studyGroupId,
      $set: { homeworkIds: homeworkIds }

  removeHomeworkFromTheGroup: (data) ->
    check data,
      studyGroupId: String
      homeworkId: Match.Optional String
    unless Roles.userIsInRole @userId, 'teacher', 'all'
      throw new Meteor.Error 401, 'Unauthorized'
    StudyGroups.update data.studyGroupId,
      $pull: { homeworkIds: data.homeworkId }

  searchUsernames: (query, options) ->
    options = options or {}
    # guard against client-side DOS: hard limit to 50
    if options.limit
      options.limit = Math.min(50, Math.abs(options.limit))
    else
      options.limit = 50
    # TODO fix regexp to support multiple tokens
    regex = new RegExp('^' + query)
    Meteor.users.find({ username: $regex: regex }, options).fetch()
