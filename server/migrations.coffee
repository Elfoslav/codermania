Meteor.startup ->
  Migrations = new Mongo.Collection('migrations')

  #This is useful migration, don't delete it
  migrationName = 'fix user points'
  unless Migrations.findOne { name: migrationName }
    Logger.log "Info: starting migration #{migrationName} at #{new Date()}", 'info'
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
    Logger.log "Info: ending migration #{migrationName} at #{new Date()}", 'info'

  migrationName = 'add isReadBy array to homework comments'
  unless Migrations.findOne { name: migrationName }
    Logger.log "Info: starting migration #{migrationName} at #{new Date()}", 'info'

    StudentHomeworkComments.update {},
      $set: { isReadBy: [] }
    ,
      multi: true

    Migrations.insert
      name: migrationName
    Logger.log "Info: ending migration #{migrationName} at #{new Date()}", 'info'
