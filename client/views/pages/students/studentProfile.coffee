Template.studentProfile.helpers
  canSeeUserExercises: ->
    Roles.userIsInRole(Meteor.userId(), 'teacher', 'all') or
      Meteor.user()?.username is Router.current().params.username
  getLessonTitle: ->
    return JSLessonsList._collection.findOne({ id: @value.id })?.title
  getLessonSlug: ->
    return JSLessonsList._collection.findOne({ id: @value.id })?.slug
  getExerciseTitle: (lessonId, exerciseId) ->
    return JSLessonsList._collection.findOne({ id: lessonId })?.exercises?[exerciseId]?.title
  #return an array of exercises which student haven't submitted
  restExercises: (lessonId) ->
    allExercises = JSLessonsList._collection.findOne({ id: lessonId })?.exercises
    userExercises = Meteor.users.findOne({ username: Router.current().params.username })?.lessons?[lessonId]?.exercises
    return [] if !allExercises or !userExercises
    restExercises = []
    for key, value of allExercises
      unless userExercises[key]
        restExercises.push value
    return restExercises
  studyGroups: ->
    StudyGroups.find({}, { sort: { timestamp: 1 } })
  showCreateStudyGroupBtn: ->
    @student.username is Meteor.user()?.username
