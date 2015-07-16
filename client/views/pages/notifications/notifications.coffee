Template.notifications.events
  'click a': (evt, tpl) ->
    console.log @
    Meteor.call 'markNotificationAsRead', @_id, (err) ->
      if err
        console.log err