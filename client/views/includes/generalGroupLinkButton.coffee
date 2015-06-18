Template.generalGroupLinkButton.onCreated ->
  @subscribe('studyGroupByName', 'general')

Template.generalGroupLinkButton.helpers
  groupId: ->
    StudyGroups.findOne({ title: 'general' })?._id