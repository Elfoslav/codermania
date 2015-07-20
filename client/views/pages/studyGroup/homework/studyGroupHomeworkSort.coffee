Template.studyGroupHomeworkSort.onRendered ->
  studyGroup = @data.studyGroup
  @$( ".homework-list" ).sortable
    stop: (evt, ui) ->
      items = $(@).sortable('toArray')
      Meteor.call 'sortStudyGroupHomework', studyGroup._id, items, (err) ->
        if err
          bootbox.alert err.reason
          console.log err