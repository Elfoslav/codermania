Meteor.publish 'userData', ->
  qry = {_id: @userId}
  Meteor.users.find qry,
    fields:
      'points': 1

Meteor.publish 'userLesson', (userId, lessonId) ->
  qry = { _id: userId }
  qry["lessons.#{lessonId}.id"] = lessonId
  fields = {}
  fields["lessons.#{lessonId}"] = 1
  Meteor.users.find qry,
    fields: fields

Meteor.publish 'studentsList', ->
  qry =
    'roles.all': 'student'

  Meteor.users.find qry,
    sort:
      'points': -1
    limit: 250
    fields:
      'roles.all': 1
      'username': 1
      'points': 1
      'status.online': 1

Meteor.publish 'studentsCount', ->
  qry =
    'roles.all': 'student'
  students = Meteor.users.find qry
  Counts.publish(this, 'studentsCount', students)
  @ready()

Meteor.reactivePublish 'sendersList', ->
  user = Meteor.users.findOne(@userId)
  throw new Meteor.Error(401, 'Not authorized') unless user

  self = @

  list = Meteor.users.find({
    username: { $ne: user?.username }
  }, {
    fields:
      'roles.all': 1
      'username': 1
      'status.online': 1
  }).fetch().map (user) ->
    unreadMsgCount = Messages.find({
      senderId: user._id
      receiverId: self.userId
      isRead: false
    }).count()

    msgCount = Messages.find({
      senderId: user._id
      receiverId: self.userId
    }, {
      reactive: true
    }).count()

    firstMsg = Messages.findOne
      senderId: user._id
      receiverId: self.userId
    ,
      fields:
        timestamp: 1
      sort:
        timestamp: -1

    user.unreadMsgCount = unreadMsgCount
    user.msgTimestamp = firstMsg?.timestamp
    if msgCount
      self.added('sendersList', user._id, user)
      #self.changed is required for reactive changes
      self.changed('sendersList', user._id, user)
    return user
  @ready()

Meteor.publish 'student', (username) ->
  check(username, String)
  Meteor.users.find { username: username },
    fields:
      emails: 0
      services: 0
      settings: 0

Meteor.publish 'studentLessonData', (username) ->
  check(username, String)
  Meteor.users.find { username: username },
    fields:
      points: 1
      username: 1
      'status.online': 1

Meteor.publish 'usernames', (query, limit) ->
  check(query, String)
  check(limit, Match.Optional Number)
  regex = new RegExp("^" + query);
  Meteor.users.find { username: { $regex: regex } },
    limit: limit || 1000,
    fields: { username: 1, roles: 1, 'status.online': 1 }

Meteor.publish 'userHTMLLessons', (data) ->
  check data,
    username: String
    lessonId: Match.Optional String
  user = Meteor.users.findOne { username: data.username }
  qry = {}
  qry.userId = user?._id
  if data.lessonId
    qry.id = data.lessonId
  UserHTMLLessons.find qry

Meteor.publish 'userCSSLessons', (data) ->
  check data,
    username: String
    lessonId: Match.Optional String
  user = Meteor.users.findOne { username: data.username }
  qry = {}
  qry.userId = user?._id
  if data.lessonId
    qry.id = data.lessonId
  UserCSSLessons.find qry

Meteor.publish 'userProgrammingChallengeLessons', (data) ->
  check data,
    username: String
    lessonId: Match.Optional String
  user = Meteor.users.findOne { username: data.username }
  qry = {}
  qry.userId = user?._id
  if data.lessonId
    qry.id = data.lessonId
  UserProgrammingChallengeLessons.find qry

Meteor.publish 'unreadMessagesCount', ->
  user = Meteor.users.findOne(@userId)

  messages = Messages.find({
    receiverId: user?._id
    isRead: false
  })

  Counts.publish(this, 'unreadMessagesCount', messages)
  @ready()

Meteor.publish 'messages', (options) ->
  check(options, {
    senderUsername: String
    receiverUsername: String
  })
  sender = Meteor.users.findOne({ username: options.senderUsername })
  receiver = Meteor.users.findOne({ username: options.receiverUsername })

  if !sender or !receiver
    @ready()
    return []

  Messages.find({
    $or: [
      {
        $and: [
          { senderId: sender._id }
          { receiverId: receiver._id }
        ]
      }
      {
        $and: [
          { senderId: receiver._id }
          { receiverId: sender._id }
        ]
      }
    ]
  }, {
    sort: { timestamp: -1 }
    limit: 55
  })

Meteor.publish 'slides', (lang) ->
  Slides.find({ lang: lang })

Meteor.publish 'code', ->
  Code.find()

Meteor.publish 'needHelp', (needHelpId, solved) ->
  check needHelpId, Match.Optional String
  check solved, Match.Optional Boolean

  qry = {}
  if needHelpId
    qry['_id'] = needHelpId
  if solved isnt undefined
    qry['solved'] = solved

  lastThreeMonths = new Date()
  lastThreeMonths.setMonth(lastThreeMonths.getMonth() - 2)
  qry.timestamp =
    $gt: lastThreeMonths.getTime()

  needHelpCoursor = NeedHelp.find(qry)
  userIds = []
  usersOpts =
    fields:
      emails: 0
      services: 0
      settings: 0
  needHelpCoursor.forEach (item) ->
    userIds.push item.userId
  if needHelpId
    NeedHelpComments.find({ needHelpId: needHelpId }).forEach (item) ->
      userIds.push item.userId
  return [
    needHelpCoursor
    NeedHelpComments.find { needHelpId: needHelpId }
    Meteor.users.find { _id: { $in: userIds }}, usersOpts
  ]

Meteor.publish 'needHelpCount', ->
  lastThreeMonths = new Date()
  lastThreeMonths.setMonth(lastThreeMonths.getMonth() - 3)
  needHelpCursor = NeedHelp.find
    solved: false
    timestamp:
      $gt: lastThreeMonths.getTime()

  Counts.publish(this, 'needHelpCount', needHelpCursor)
  @ready()

Meteor.publish 'needHelpForLessonAndUser', (lessonId, username) ->
  needHelpCoursor = NeedHelp.find({ lessonId: lessonId, username: username, solved: false })
  needHelpIds = []
  needHelpCoursor.forEach (item) ->
    needHelpIds.push item._id
  return [
    needHelpCoursor
    NeedHelpComments.find({ needHelpId: { $in: needHelpIds }})
  ]

Meteor.publish 'userStudyGroups', (username) ->
  user = Meteor.users.findOne({ username: username })
  loggedInUser = Meteor.users.findOne @userId
  return this.ready() if !user
  if username == loggedInUser?.username
    #created or joined groups
    StudyGroups.find
      $or: [
        { userId: user._id }
        { userIds: { $in: [ user._id ] }}
      ]
  else
    #public joined groups
    StudyGroups.find
      isPublic: true
      $or: [
        { userId: user._id }
        { userIds: { $in: [ user._id ] }}
      ]

Meteor.reactivePublish 'studyGroup', (id) ->
  studyGroup = StudyGroups.findOne(id)
  messagesCursor = StudyGroupMessages.find { studyGroupId: id },
    limit: 120
    sort:
      timestamp: 1
    reactive: true #required for reactive-publish package
  userIds = studyGroup?.userIds || []
  #this is not reactive by default, there is a package for reactivity: https://atmospherejs.com/lepozepo/reactive-publish
  messagesCursor.forEach (message) ->
    if userIds.indexOf(message.userId) is -1
      userIds.push message.userId
  [
    StudyGroupCurriculums.find({ _id: studyGroup.curriculumId })
    StudyGroups.find({ _id: id })
    messagesCursor
    Meteor.users.find { _id: $in : userIds },
      fields: { username: 1, roles: 1, 'status.online': 1 }
  ]

Meteor.publish 'studyGroupByName', (title) ->
  studyGroup = StudyGroups.findOne({ title: title })
  return [
    StudyGroupCurriculums.find({ _id: studyGroup.curriculumId })
    StudyGroups.find({ title: title })
  ]

Meteor.publish 'studyGroups', (limit) ->
  check(limit, Match.Optional Number)
  StudyGroups.find
    $or: [
      { isPublic: true }
      { userIds: $in: [ @userId ] }
    ]
  ,
    limit: limit || 0

Meteor.publish 'summerWebDevSchoolStudyGroups', (lang) ->
  if lang is 'en'
    return StudyGroups.find
        title: 'Web development school 2015'
  StudyGroups.find
    $or: [
      { title: 'Letná web developerská škola 2015' }
      { title: 'Online letná web developerská škola 2015' }
    ]

Meteor.publish 'homepageStudyGroups', ->
  StudyGroups.find { isPublic: true },
    sort: { timestamp: 1 }
    limit: 3

Meteor.publish 'unreadStudyGroupMessagesCount', (studyGroupId) ->
  check studyGroupId, Match.Optional String

  if studyGroupId
    studyGroup = StudyGroups.findOne
      _id: studyGroupId
      userIds: $in: [ @userId ]

    messagesCursor = StudyGroupMessages.find
      studyGroupId: studyGroupId
      isReadBy: $nin: [ @userId ]
    ,
      limit: 500

    if studyGroup
      Counts.publish(this, 'unreadStudyGroupMessagesCount' + studyGroupId, messagesCursor)
  else
    studyGroups = StudyGroups.find
      userIds: $in: [ @userId ]

    studyGroupIds = studyGroups.map (studyGroup) ->
      studyGroup._id

    messagesCursor = StudyGroupMessages.find
      studyGroupId: $in: studyGroupIds
      isReadBy: $nin: [ @userId ]
    ,
      limit: 500

    Counts.publish(this, 'unreadStudyGroupMessagesCount', messagesCursor)
  @ready()

Meteor.publish 'curriculums', (id) ->
  check id, Match.Optional String
  if id
    return StudyGroupCurriculums.findOne(id)
  StudyGroupCurriculums.find({ createdBy: @userId })

Meteor.publish 'userSettings', ->
  Meteor.users.find { _id: @userId },
    fields:
      settings: 1

Meteor.reactivePublish 'homework', (query, options) ->
  query = query || {}
  options = options || {}
  check query,
    _id: Match.Optional String
    userId: Match.Optional String
    studyGroupId: Match.Optional String
  check options,
    limit: Match.Optional Number

  if query._id
    return Homework.findOne(query._id)
  if query.studyGroupId
    studyGroup = StudyGroups.findOne(query.studyGroupId, { reactive: true })
    return Homework.find({ _id: { $in: studyGroup.homeworkIds }})
  Homework.find(query, options)

Meteor.publish 'studentHomework', (query, username) ->
  check query,
    homeworkId: Match.Optional String
  check username, String
  user = Meteor.users.findOne { username: username }
  unless user
    Logger.log "studentHomework publication: Student with username #{username} not found", "warning"
    return @ready()
  query.userId = user._id
  StudentHomework.find query

Meteor.publish 'studentHomeworkComments', (query) ->
  check query,
    studentHomeworkId: String
  StudentHomeworkComments.find query

Meteor.publish 'notifications', ->
  user = Meteor.users.findOne @userId
  AppNotifications.find
    userIds: { $in: [ user?._id ] }
    isReadBy: { $nin: [ user?._id ] }
  ,
    limit: 100

Meteor.publish 'notificationsCount', ->
  user = Meteor.users.findOne @userId
  notifications = AppNotifications.find
    userIds: { $in: [ user?._id ] }
    isReadBy: { $nin: [ user?._id ] }

  Counts.publish(this, 'notificationsCount', notifications)
  @ready()
