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
    limit: 250
    fields:
      'roles.all': 1
      'username': 1
      'points': 1
      'status': 1

Meteor.publish 'sendersList', ->
  user = Meteor.users.findOne(@userId)
  throw new Meteor.Error(401, 'Not authorized') unless user

  self = @

  list = Meteor.users.find({
    username: { $ne: user?.username }
  }, {
    fields:
      'roles.all': 1
      'username': 1
      'status': 1
    limit: 50
  }).fetch().map (user) ->
    unreadMsgCount = Messages.find({
      senderId: user._id
      receiverId: self.userId
      isRead: false
    }).count()

    msgCount = Messages.find({
      senderId: user._id
      receiverId: self.userId
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
    return user
  @ready()

Meteor.publish 'student', (username) ->
  check(username, String)
  Meteor.users.find { username: username },
    fields:
      emails: 0
      services: 0
      settings: 0

Meteor.publish 'usernames', (query, limit) ->
  check(query, String)
  check(limit, Match.Optional Number)
  regex = new RegExp("^" + query);
  Meteor.users.find { username: { $regex: regex } },
    limit: limit || 1000,
    fields: { username: 1, roles: 1, status: 1 }

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
    receiverUsername: user?.username
    isRead: false
  })

  Counts.publish(this, 'unreadMessagesCount', messages)
  @ready()

Meteor.publish('messages', (options) ->
  check(options, {
    senderUsername: String
    receiverUsername: String
  })
  user = Meteor.users.findOne({
    $or: [
      { username: options.senderUsername }
      { username: options.receiverUsername }
    ]
  })

  unless user
    console.log('messages user: ', user)
    console.log('messages senderUsername: ', options.senderUsername)
    console.log('messages receiverUsername: ', options.receiverUsername)
    @ready()
    return []

  Messages.find({
    $or: [
      {
        $and: [
          { senderUsername: options.senderUsername }
          { receiverUsername: options.receiverUsername }
        ]
      }
      {
        $and: [
          { senderUsername: options.receiverUsername }
          { receiverUsername: options.senderUsername }
        ]
      }
    ]
  }, {
    sort: { timestamp: -1 }
    limit: 50
  })
)

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
  return this.ready() unless user
  if username == loggedInUser.username
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
    StudyGroups.find({ _id: id })
    messagesCursor
    Meteor.users.find { _id: $in : userIds },
      fields: { username: 1, roles: 1, status: 1 }
  ]

Meteor.publish 'studyGroups', ->
  StudyGroups.find
    $or: [
      { isPublic: true }
      { userIds: $in: [ @userId ] }
    ]

Meteor.publish 'summerWebDevSchoolStudyGroup', ->
  StudyGroups.find
    title: 'Letná web developerská škola 2015'

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

Meteor.publish 'userSettings', ->
  Meteor.users.find { _id: @userId },
    fields:
      settings: 1
