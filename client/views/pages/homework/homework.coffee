Template.homework.onRendered ->
  list = document.getElementById("homework-list")
  Sortable.create list,
    group: { name: 'homework', pull: 'clone', put: false }
    sort: false

  list = document.getElementById("study-group-list")
  for k, v of list.childNodes
    if v and v.nodeType is 1
      Sortable.create $(v).find('.study-group-homework-list')[0],
        group: 'homework'
        onUpdate: (evt) ->
          items = $(evt.item).parent().find('li')
          homeworkIds = items.toArray().map (item) ->
            return item.getAttribute('data-id')
          Meteor.call 'sortStudyGroupHomework', evt.from.id, homeworkIds, (err) ->
            if err
              bootbox.alert err.reason
              console.log err
        onAdd: (evt) ->
          $item = $(evt.item)
          items = $item.parent().find('li')
          homeworkIds = items.toArray().map (item) ->
            return item.getAttribute('data-id')
          Meteor.call 'sortStudyGroupHomework', $item.parent().attr('id'), homeworkIds, (err) ->
            if err
              bootbox.alert err.reason
              console.log err
            else
              $item.remove()

Template.homework.events
  'click .remove-homework-from-the-group': (evt, tpl) ->
    evt.preventDefault()
    return false unless confirm('Are you sure you want to delete the homework?')
    #tpl.parentData(1) somehow does not work, we need to get id from the data attr
    studyGroupId = evt.currentTarget.getAttribute('data-study-group-id')
    Meteor.call 'removeHomeworkFromTheGroup', { studyGroupId: studyGroupId, homeworkId: @_id }, (err) ->
      if err
        bootbox.alert err.reason
        console.log err
