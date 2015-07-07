Meteor.methods
  slideLeft: (slide) ->
    check slide, Object
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    prevSlideNumber = slide.currentSlideNumber - 1
    unless prevSlideNumber < 1
      Slides.update({ lang: slide.lang }, {
        $set:
          currentSlideNumber: prevSlideNumber
          currentSlideTemplate: 'skSlide' + prevSlideNumber
      })

  slideRight: (slide) ->
    check slide, Object
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    nextSlideNumber = slide.currentSlideNumber + 1
    Slides.update({ lang: slide.lang }, {
      $set:
        currentSlideNumber: nextSlideNumber
        currentSlideTemplate: 'skSlide' + nextSlideNumber
    })

  setSlideNumber: (slideNumber) ->
    check slideNumber, Number
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    Slides.update({ lang: 'sk' }, {
      $set:
        currentSlideNumber: slideNumber
        currentSlideTemplate: 'skSlide' + slideNumber
    })

  saveHtmlCode: (code) ->
    check(code, String)
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    existing = Code.findOne({ type: 'html' })
    if existing
      Code.update({ type: 'html' }, {
        $set:
          code: code
      })
    else
      Code.insert
        type: 'html'
        code: code

  saveJsCode: (code) ->
    check(code, String)
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    existing = Code.findOne({ type: 'js' })
    if existing
      Code.update({ type: 'js' }, {
        $set:
          code: code
      })
    else
      Code.insert({
        type: 'js'
        code: code
      })

  saveNeedHelpComment: (opts) ->
    check(opts.needHelpId, String)
    check(opts.lesson, Object)
    check(opts.sendEmail, Match.Optional Boolean)
    check(opts.msg, String)
    check(opts.url, String)
    check(opts.lang, String)
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    user = Meteor.users.findOne(@userId)
    if Meteor.isServer
      commentsCount = NeedHelpComments.find
        needHelpId: opts.needHelpId
      .count()

      needHelp = NeedHelp.findOne opts.needHelpId
      elfoslavUser = Meteor.users.findOne({ username: 'elfoslav' })
      if needHelp.username != user.username
        App.insertMessage
          senderId: elfoslavUser._id
          senderUsername: elfoslavUser.username
          receiverId: needHelp.user?._id
          receiverUsername: needHelp.user?.username
          needHelpId: needHelp._id
          text: """
            (auto generated message) Hello, you asked for help and someone answered it.
            Read the answer here: #{Meteor.absoluteUrl()}help/#{needHelp._id}
          """

      if opts.sendEmail
        console.log 'sending need help email to', needHelp.user.emails?[0]?.address
        mailBody = """
          You asked for help and #{user.username} is trying to help you:
          <a href=\"#{opts.url}\">#{opts.url}</a>
        """
        if needHelp.user.emails?[0]?.address != user?.emails?[0]?.address
          @unblock()
          Email.send
            from: user?.emails?[0]?.address || 'info@codermania.com'
            to: needHelp.user.emails?[0].address
            subject: "CoderMania - New comment in need help #{opts.lesson.title}"
            html: mailBody

    NeedHelpComments.insert
      needHelpId: opts.needHelpId
      userId: user?._id
      username: user?.username
      text: opts.msg
      timestamp: Date.now()
      lang: opts.lang
      readBy: []

  markNeedHelpSolved: (needHelpId) ->
    check needHelpId, String
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    NeedHelp.update needHelpId,
      $set:
        solved: true

  markNeedHelpUnsolved: (needHelpId) ->
    check needHelpId, String
    unless Roles.userIsInRole(@userId, [ 'teacher' ], 'all')
      throw new Meteor.Error(403, 'Unauthorized')
    NeedHelp.update needHelpId,
      $set:
        solved: false

  joinStudyGroup: (data) ->
    check data,
      studyGroupId: String

    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    userStudyGroup = StudyGroups.findOne
      _id: data.studyGroupId
      userIds: $in: [ @userId ]

    if userStudyGroup
      throw new Meteor.Error('already-joined', 'You already are in this group')

    studyGroup = StudyGroups.findOne
      _id: data.studyGroupId

    if studyGroup.capacity != 0 and studyGroup.capacity <= studyGroup.userIds.length
      studyGroupCreator = Meteor.users.findOne(studyGroup.userId)
      user = Meteor.users.findOne(@userId)
      username = user.username.replace(' ', '%20')
      if user._id != studyGroupCreator._id
        App.insertMessage
          senderId: user._id
          senderUsername: user.username
          receiverId: studyGroupCreator._id
          receiverUsername: studyGroupCreator.username
          text: """
            Hi, I am interested in joining
            #{Meteor.absoluteUrl()}study-groups/#{studyGroup._id}
            study group.
          """
      throw new Meteor.Error('group-capacity',
        'Sorry, this group is already full. We have notified the teacher about your interest.')

    StudyGroups.update data.studyGroupId,
      $push: userIds: @userId

  leaveStudyGroup: (data) ->
    check data,
      studyGroupId: String

    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    StudyGroups.update data.studyGroupId,
      $pull: userIds: @userId

  saveStudyGroupMessage: (data) ->
    check data,
      studyGroupId: String
      text: String
      sendNotifications: Boolean
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')

    StudyGroupMessages.insert
      studyGroupId: data.studyGroupId
      text: data.text
      userId: @userId
      timestamp: Date.now()
      isReadBy: [ @userId ]

    if data.sendNotifications and Meteor.isServer
      studyGroup = StudyGroups.findOne(data.studyGroupId)
      currentUser = Meteor.users.findOne(@userId)
      emails = []
      users = Meteor.users.find({ _id: { $in: studyGroup.userIds }})
      users.forEach (user) ->
        if currentUser._id != user._id
          emails.push(user.emails?[0]?.address)
      studyGroupUrl = Meteor.absoluteUrl() + 'study-groups/' + studyGroup._id
      msg = """
        <p>
          Hi,<br><br>
          #{currentUser.username} has posted a message in study group.
          Go to <a href='#{studyGroupUrl}'>#{studyGroupUrl}</a> to see the message.
        </p>
        <p>If you don't want to receive these e-mails, leave the study group.</p>
      """
      @unblock()
      Email.send
        from: 'info@codermania.com'
        bcc: emails
        subject: "New message in a study group on CoderMania"
        html: msg

  updateUserSettings: (data) ->
    check data,
      studyGroupNotifications: Match.Optional String
    data.userId = @userId
    Meteor.users.update
      _id: @userId
    ,
      $set:
        'settings.emailNotifications.studyGroupNotifications': data.studyGroupNotifications

  changeUsername: (username) ->
    check username, String
    unless @userId
      throw new Meteor.Error(401, 'To perform this action, you have to be logged in')
    unless username
      throw new Meteor.Error('empty username', 'Username cannot be empty')
    existingUser = Meteor.users.findOne({ username: username })
    if existingUser
      throw new Meteor.Error('user already exists',
        'User with given username already exists, choose another username')

    user = Meteor.users.findOne(@userId)
    Messages.update
      receiverUsername: user.username
    ,
      $set:
        receiverUsername: username
    ,
      multi: true

    Messages.update
      senderUsername: user.username
    ,
      $set:
        senderUsername: username
    ,
      multi: true

    NeedHelpComments.update
      username: user.username
    ,
      $set:
        username: username
    ,
      multi: true

    Meteor.users.update(@userId, {
      $set:
        username: username
    })

  sendMessage: (options) ->
    check(options, {
      username: String #receiver's username
      sendEmail: Boolean
      message: String
    })

    throw new Meteor.Error(401, 'Unauthorized!') unless @userId

    sender = Meteor.users.findOne(Meteor.userId())
    receiver = Meteor.users.findOne({ username: options.username })
    App.insertMessage
      senderId: Meteor.userId()
      senderUsername: sender.username
      receiverId: receiver._id
      receiverUsername: receiver.username
      text: options.message

    if options.sendEmail and Meteor.isServer
      @unblock()
      App.sendEmailAboutMessage
        sender: sender
        receiver: receiver

  createHomework: (data, studyGroupId) ->
    check data,
      title: String
      description: String
    console.log 'studyGroupId', studyGroupId
    check studyGroupId, Match.Optional String

    existingHomework = Homework.findOne { title: data.title }
    if existingHomework
      throw new Meteor.Error '', "Homework with title #{data.title} already exists, try to change title."

    homeworkId = Homework.insert data
    if studyGroupId
      StudyGroups.update studyGroupId,
        { $push: { homeworkIds: homeworkId } }

  updateHomework: (data, studyGroupId) ->
    check data,
      _id: String
      title: String
      description: String
    check studyGroupId, Match.Optional String

    existingHomework = Homework.findOne { title: data.title }
    if existingHomework
      throw new Meteor.Error '', "Homework with title #{data.title} already exists, try to change title."

    Homework.update data._id,
      $set: data
