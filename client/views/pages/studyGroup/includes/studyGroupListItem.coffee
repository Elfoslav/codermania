Template.studyGroupListItem.onCreated ->
  @subscribe 'unreadStudyGroupMessagesCount', @data._id

Template.studyGroupListItem.helpers
  unreadStudyGroupMessagesCount: (studyGroupId) ->
    Counts.get('unreadStudyGroupMessagesCount' + studyGroupId)
  studentsCount: (studyGroupId) ->
    return 0 unless @userIds
    @userIds.length
  joined: ->
    return false unless @userIds
    @userIds.indexOf(Meteor.userId()) != -1