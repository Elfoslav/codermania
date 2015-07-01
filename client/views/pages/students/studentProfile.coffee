Template.studentProfile.helpers
  canSeeUserExercises: ->
    Roles.userIsInRole(Meteor.userId(), 'teacher', 'all') or
      Meteor.user()?.username is Router.current().params.username
  studyGroups: ->
    user = Meteor.users.findOne({ username: Router.current().params.username })
    StudyGroups.find({ userIds: { $in: [ user?._id ] }}, { sort: { timestamp: 1 } })
  showCreateStudyGroupBtn: ->
    @student.username is Meteor.user()?.username
  lessons: ->
    LessonsList.getLessons()
  exercisesArray: ->
    arr = []
    for key, value of @exercises
      arr.push value
    return arr
  studentLesson: ->
    Template.parentData(1).student.lessons?[@id]
  studentExercise: ->
    lesson = Template.parentData(1)
    Template.parentData(2).student.lessons?[lesson.id]?.exercises?[@id]
