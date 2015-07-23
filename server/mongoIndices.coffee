Meteor.startup ->
  StudentHomework._ensureIndex
    userId: 1
    homeworkId: 1

  StudentHomeworkComments._ensureIndex
    studentHomeworkId: 1

  StudyGroups._ensureIndex
    userIds: 1

  StudyGroups._ensureIndex
    title: 1

  StudyGroups._ensureIndex
    isPublic: 1

  StudyGroupMessages._ensureIndex
    studyGroupId: 1
    isReadBy: 1

  Messages._ensureIndex
    receiverId: 1

  Messages._ensureIndex
    senderId: 1

  Messages._ensureIndex
    isRead: 1

  NeedHelp._ensureIndex
    lessonId: 1
    username: 1
    solved: 1

  NeedHelp._ensureIndex
    solved: 1

  NeedHelp._ensureIndex
    timesatamp: 1

  NeedHelpComments._ensureIndex
    needHelpId: 1

  AppNotifications._ensureIndex
    userIds: 1

  AppNotifications._ensureIndex
    sourceId: 1
