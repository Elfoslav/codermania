Template.studyGroup.onCreated ->
  @shownCurriculum = new ReactiveVar(false)

Template.studyGroup.helpers
  canEdit: ->
    route = Router.current()
    studyGroup = StudyGroups.findOne(route.params._id)
    Meteor.userId() is studyGroup?.userId or Roles.userIsInRole(Meteor.userId(), 'admin', 'all')
  isJoined: ->
    return false unless Meteor.userId()
    route = Router.current()
    studyGroup = StudyGroups.findOne
      _id: route.params._id
      userIds: $in: [ Meteor.userId() ]
    !!studyGroup
  makeRead: ->
    if @isReadBy?.indexOf(Meteor.userId()) is -1
      studyGroupId = Router.current().params._id
      Meteor.call('markStudyGroupMessagesAsRead', studyGroupId)
  getUsername: ->
    Meteor.users.findOne(@userId)?.username
  isUserOnline: ->
    Meteor.users.findOne(@userId)?.status?.online
  getRole: ->
    if Roles.userIsInRole(@user?._id, 'teacher', 'all') then '(teacher)' else ''
  students: ->
    Meteor.users.find
      _id: { $in: @studyGroup?.userIds || [] }
      'roles.all': { $in: [ 'student' ]}
  teachers: ->
    Meteor.users.find
      _id: { $in: @studyGroup?.userIds || [] }
      'roles.all': { $in: [ 'teacher' ]}
  freeSpotsCount: ->
    @capacity - @userIds?.length
  curriculum: ->
    route = Router.current()
    studyGroup = StudyGroups.findOne(route.params._id)
    StudyGroupCurriculums.findOne(studyGroup?.curriculumId)
  shownCurriculum: ->
    return Template.instance().shownCurriculum.get()

Template.studyGroup.events
  'click [data-target="#study-group-modal"]': (evt) ->
    route = Router.current()
    studyGroup = StudyGroups.findOne(route.params._id)
    for key, value of studyGroup
      $el = $('#study-group-form [name="' + key + '"]')
      if $el[0]?.type is 'checkbox'
        $el.prop('checked', value)
      $el.val(value)
  'click .join-group-btn': (evt) ->
    evt.preventDefault()
    return bootbox.alert('To join this group you have to be signed in') unless Meteor.userId()
    data =
      studyGroupId: Router.current().params._id
    Meteor.call 'joinStudyGroup', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        bootbox.alert 'Congratulations, you have successfuly joined this group!'
  'click .leave-group-btn': (evt) ->
    return 0 unless confirm 'Are you sure you want to leave this group?'
    data =
      studyGroupId: Router.current().params._id
    Meteor.call 'leaveStudyGroup', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
  'submit #study-group-chat-form': (evt) ->
    evt.preventDefault()
    textarea = evt.target.text
    message = textarea.value
    textarea.value = ''
    sendNotifications = evt.target.sendNotifications.checked
    return bootbox.alert('Write something') if $.trim(message) is ''
    data =
      studyGroupId: Router.current().params._id
      text: message
      sendNotifications: sendNotifications
    Meteor.call 'saveStudyGroupMessage', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
        textarea.value = message
  'click .toggle-curriculum': (evt, tpl) ->
    evt.preventDefault()
    tpl.shownCurriculum.set(!tpl.shownCurriculum.get())
