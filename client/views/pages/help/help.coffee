Template.help.helpers
  isUnread: (needHelpId) ->
    if Meteor.userId()
      Meteor.call 'getNeedHelpCommentsCounter', needHelpId, (err, res) ->
        Session.set("isUnread#{needHelpId}", res)
    return Session.get("isUnread#{needHelpId}")