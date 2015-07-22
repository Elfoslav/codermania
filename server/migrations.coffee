Meteor.startup ->
  Migrations = new Mongo.Collection('migrations')

  migration1Name = 'fix user points'
  unless Migrations.findOne { name: migration1Name }
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
      name: migration1Name
    Logger.log "Info: ending migration fix user points at #{new Date()}", 'info'
