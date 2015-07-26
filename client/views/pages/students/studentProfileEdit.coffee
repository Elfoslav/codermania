Template.studentProfileEdit.onRendered ->
  summernote = @$('#about-me').summernote
    toolbar: [
      ['style', ['bold', 'italic', 'underline', 'clear']]
      ['para', ['ul', 'ol']]
      ['link', ['link', 'picture']]
    ]
  if @data?.student.profile.about
    summernote.code(@data.stutent.profile.about)

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