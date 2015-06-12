Template.facebook.onRendered ->
  if Meteor.absoluteUrl().indexOf('localhost') != -1
    FB?.init
      appId: '866173586763728'
      status: true
      xfbml: true
    console.log 'fb init localhost'
  else
    FB?.init
      appId: '721325117884948'
      status: true
      xfbml: true
    console.log 'fb init production'
