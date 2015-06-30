Meteor.methods
  saveUserLesson: (username, lesson) ->
    check username, String
    check lesson,
      id: String
      type: String #javascript|html|css|programming-challenge
      slug: String
      number: Number
      code: String
      success: Boolean

    user = Meteor.users.findOne({ username: username })
    unless user?._id == @userId or Roles.userIsInRole(@userId, 'teacher', 'all')
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


    #add points before updating user
    if lesson.success
      if (userLesson is undefined) or !userLesson?.pointsAdded
        Meteor.users.update(user._id, {
          $inc: { points: lessonPoints }
        })
        if lesson.type is 'javascript'
          qry["lessons.#{lesson.id}.pointsAdded"] = true
        else
          lesson.pointsAdded = true
        console.log 'lesson after points added: ', user.points

        if lesson.type is 'programming-challenge'
          elfoslav = Meteor.users.findOne({ username: 'elfoslav' })
          username = user.username.replace(' ', '%20')
          if user._id != elfoslav._id
            App.insertMessage
              senderId: user._id
              senderUsername: user.username
              receiverId: elfoslav._id
              receiverUsername: elfoslav.username
              text: """
                I have finished programming challenge lesson
                #{Meteor.absoluteUrl()}programming-challenge/lesson/#{lesson.id}/#{lesson.slug}/#{username}
              """
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
      return UserProgrammingChallengeLessons.upsert
        userId: @userId
        id: lesson.id
      ,
        $set: lesson

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

    unless userId == @userId or Roles.userIsInRole(@userId, 'teacher', 'all')
      throw new Meteor.Error(401, 'Access denied')

    points = 2 #get 2 points for each exercise
    exercise.date = new Date()
    exercise.timestamp = new Date().getTime()
    exercise.changedBy = @userId
    exercise.points = points

    user = Meteor.users.findOne(userId)
    userExercise = user?.lessons?[lesson.id]?.exercises?[exercise.id]
    exercise.pointsAdded = userExercise?.pointsAdded

    #add points before updating user
    console.log('userExercise: ', userExercise)
    if exercise.success
      if (userExercise is undefined) or !userExercise.pointsAdded
        Meteor.users.update(userId, {
          $inc: { points: points }
        })
        exercise.pointsAdded = true
        console.log 'lesson after points added: ', Meteor.users.findOne(userId).points
      console.log "updating need help for exercise: #{exercise.id} and user #{user.username}"
      NeedHelp.update { exerciseId: exercise.id, username: user.username },
        $set: { solved: true }

    NeedHelp.update { exerciseId: exercise.id, username: user.username },
      $set: { lessonCode: exercise.code }

    qry = {}
    qry["lessons.#{lesson.id}.exercises.#{exercise.id}"] = exercise
    console.log 'qry', qry
    Meteor.users.update(userId, {
      $set: qry
    })

  askForHelp: (lesson, message) ->
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

  unreadMessagesCount: ->
    user = Meteor.users.findOne(@userId)

    Messages.find({
      receiverUsername: user?.username
      isRead: false
    }).count()

  markMessagesAsRead: (senderUsername) ->
    check(senderUsername, String)
    throw new Meteor.Error(401, 'Unauthorized!') unless @userId
    console.log 'markMessagesAsRead: ', senderUsername
    Messages.update({
      senderUsername: senderUsername
      receiverId: @userId
    }, {
      $set:
        isRead: true
    }, {
      multi: true
    })

  getNeedHelpCount: ->
    NeedHelp.find
      solved: false
    .count()

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
