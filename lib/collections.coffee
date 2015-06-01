#lessonId
#lessonCode
#userId
#teacherId
#message
#comments: NeedHelpComments
#timestamp
#solved
@NeedHelp = new Mongo.Collection 'needHelp',
  transform: (doc) ->
    if Meteor.isClient
      doc.lesson = JSLessonsList._collection.findOne { id: doc.lessonId }

    doc.comments = NeedHelpComments.find({ needHelpId: doc._id }, { sort: { timestamp: 1 } })
    doc.user = Meteor.users.findOne doc.userId
    return doc

#needHelpId: String
#text: String
#userId: String
#username: String
#timestamp: Date.now()
#lang: String
#isRead: Boolean
@NeedHelpComments = new Mongo.Collection 'needHelpComments'

#senderId
#senderUsername
#receiverId
#receiverUsername
#text
#timestamp
#isRead
@Messages = new Mongo.Collection('messages')

#READ ONLY - senders list for messages
@SendersList = new Mongo.Collection('sendersList')

# Meteor.users
# ============:
# lastLesson: Object
# points: Number
# profile: Object
# roles: Object
# status: Object
# username: String
# lessons {
#  lessonId: {
#    id: String
#    changedBy: String (userId)
#    code: String
#    success: Boolean
#    pointsAdded: Boolean
#    points: Number
#    timestamp: Number
#    exercises:
#      exerciseId: {
#        id: String
#        changedBy: String (userId)
#        code: String
#        success: Boolean
#        pointsAdded: Boolean
#        points: Number
#        timestamp: Number
#      }
#    }
#  }
# settings: {
#  emailNotifications: {
#   sendStudyGroupsActivity: 'turn-off'|'daily'|'weekly'|'monthly'
#  }
# }
#}

#{
#  id: String
#  userId: String
#  changedBy: String (userId)
#  code: String
#  success: Boolean
#  pointsAdded: Boolean
#  points: Number
#  timestamp: Number
#  exercises: {
#    id: String
#    changedBy: String (userId)
#    code: String
#    success: Boolean
#    pointsAdded: Boolean
#    points: Number
#    timestamp: Number
#  }
#}
@UserHTMLLessons = new Mongo.Collection 'userHTMLLessons'
#UserCSSLessons may differ from UserHTMLLessons in the future
@UserCSSLessons = new Mongo.Collection 'userCSSLessons'
@UserProgrammingChallengeLessons = new Mongo.Collection 'userProgrammingChallengeLessons'

#{
#  title: String
#  topics: String
#  studentsCount: Number
#  description: String
#  isPublic: Boolean
#  userId: String
#  userIds: [ String ]
#}
@StudyGroups = new Mongo.Collection 'studyGroups',
  transform: (doc) ->
    doc.messages = StudyGroupMessages.find({ studyGroupId: doc._id }, { sort: { timestamp: 1 } })
    return doc

#studyGroupId: String
#text: String
#userId: String
#timestamp: Date.now()
#isReadBy: [ { userId: String} ]
@StudyGroupMessages = new Mongo.Collection 'studyGroupMessages',
  transform: (doc) ->
    doc.user = Meteor.users.findOne doc.userId
    return doc

@Slides = new Mongo.Collection('slides')


# {
#  type: String (html,js)
#  code: String
#}
@Code = new Mongo.Collection('code')
