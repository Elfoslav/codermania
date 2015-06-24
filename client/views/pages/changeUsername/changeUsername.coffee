Template.changeUsername.helpers
  usernameIsEmail: ->
    Meteor.user()?.username?.indexOf('@') != -1

Template.changeUsername.events
  'submit .change-username-form': (evt, tpl) ->
    evt.preventDefault()
    username = $.trim(evt.target.username.value)
    Meteor.call 'changeUsername', username, (err, result) ->
      if err
        bootbox.alert(err.reason)