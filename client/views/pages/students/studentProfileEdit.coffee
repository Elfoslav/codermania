Template.studentProfileEdit.events
  'submit .profile-form': (evt, tpl) ->
    evt.preventDefault()
    data = $(evt.target).serializeJSON()
    console.log data
    Meteor.users.update Meteor.userId(),
      $set: { profile: data }
    , (err) ->
      if err
        bootbox.alert 'An error occured, try again'
        console.log err
      else
        Alerts.set('Successfuly saved', 'success')