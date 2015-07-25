Meteor.startup ->
  Migrations = new Mongo.Collection('migrations')

  migrationName = 'fix user points'
  unless Migrations.findOne { name: migrationName }
    Logger.log "Info: starting migration fix user points at #{new Date()}", 'info'
    users = Meteor.users.find()
    users.forEach (user) ->
      userPoints = 0
      for jsLessonId, jsLesson of user.lessons
        if jsLesson.success
          userPoints += jsLesson.points
        if jsLesson.exercises
          for jsLessonExerciseId, jsLessonExercise of jsLesson.exercises
            if jsLessonExercise.success
              userPoints += jsLessonExercise.points
      UserProgrammingChallengeLessons.find({ userId: user._id }).forEach (challenge) ->
        if challenge.success
          userPoints += challenge.points
      Meteor.users.update user._id,
        $set: { points: userPoints }

    Migrations.insert
      name: migrationName
    Logger.log "Info: ending migration fix user points at #{new Date()}", 'info'

  migrationName = 'aggregate sendersList'
  unless Migrations.findOne { name: migrationName }
    Logger.log "Info: starting migration #{migrationName} at #{new Date()}", 'info'
    users = Meteor.users.find {},
      fields:
        _id: 1
        username: 1
      reactive: false

    users.forEach (currentUser) ->
      list = Meteor.users.find({
        username: { $ne: currentUser?.username }
      }, {
        fields:
          _id: 1
          username: 1
        reactive: false
      }).fetch().map (user) ->
        unreadMsgsCount = Messages.find({
          senderId: user._id
          receiverId: currentUser._id
          isRead: false
        }, { reactive: false }).count()

        msgCount = Messages.find({
          senderId: user._id
          receiverId: currentUser._id
        }, {
          reactive: false
        }).count()

        firstMsg = Messages.findOne
          senderId: user._id
          receiverId: currentUser._id
        ,
          fields:
            timestamp: 1
          sort:
            timestamp: -1
          reactive: false

        user.unreadMsgsCount = unreadMsgsCount
        user.msgTimestamp = firstMsg?.timestamp
        if firstMsg
          existingSendersList = SendersList.findOne
            senderId: user._id, receiverId: currentUser._id
          ,
            reactive: false
          if existingSendersList
            SendersList.update { senderId: user._id, receiverId: currentUser._id },
              $set:
                lastMsgTimestamp: user.msgTimestamp
              $inc: { unreadMsgsCount: 1 }
          else
            SendersList.insert
              senderId: user._id
              senderUsername: user.username
              receiverId: currentUser._id
              lastMsgTimestamp: user.msgTimestamp
              unreadMsgsCount: unreadMsgsCount

        return user

    Migrations.insert
      name: migrationName
    Logger.log "Info: ending migration #{migrationName}  at #{new Date()}", 'info'
