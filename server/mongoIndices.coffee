Meteor.startup ->
  StudentHomework._ensureIndex
    userId: 1
    homeworkId: 1

  StudentHomeworkComments._ensureIndex
    studentHomeworkId: 1

  AppNotifications._ensureIndex
    userIds: 1

  AppNotifications._ensureIndex
    sourceId: 1