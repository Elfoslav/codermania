Template.navbar.helpers
  needHelpCount: ->
    Meteor.call 'getNeedHelpCount', (err, result) ->
      Session.set('needHelpCounter', result)
    Session.get('needHelpCounter')