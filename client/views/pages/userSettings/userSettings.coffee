Template.userSettings.helpers
  studyGroupNotifOptionSelected: (option) ->
    userSettings = Meteor.user()?.settings
    option is userSettings?.emailNotifications?.studyGroupNotifications ||
      !userSettings?.emailNotifications?.studyGroupNotifications and option is 'weekly'

Template.userSettings.events
  'change #study-group-notifications': (evt, tpl) ->
    console.log evt.target.value
    data = {}
    data.studyGroupNotifications = evt.target.value
    Meteor.call 'updateUserSettings', data, (err, result) ->
      if err
        $('#study-group-notifications-help-block')
          .addClass('red in')
          .removeClass('green out')
          .text(err.reason)
        console.log err
      else
        $('#study-group-notifications-help-block')
          .addClass('green in')
          .removeClass('red out')
          .text("Successfuly saved")
      Meteor.setTimeout ->
        $('#study-group-notifications-help-block')
          .removeClass('in')
          .addClass('out')
      , 3000
