Template.messages.helpers
  usernames: ->
    usernames = []
    if Roles.userIsInRole(Meteor.userId(), 'teacher', 'all')
      usernames = Meteor.users.find({
        username: { $ne: Meteor.user()?.username }
      }).fetch().map((user)->
        return user.username
      )
    else
      usernames = Meteor.users.find({
        username: { $ne: Meteor.user()?.username }
        'roles.all': { $in: ['teacher'] }
      }).fetch().map((user)->
        return user.username
      )
    return usernames
  sendersList: ->
    SendersList.find {},
      sort:
        msgTimestamp: -1
  selectedUsername: ->
    Router.current().params.username == @toString()
  showUsername: (receiverId) ->
    if Meteor.userId() == receiverId
      return @senderUsername
    return Meteor.user()?.username
  getRole: ->
    if Roles.userIsInRole(@senderId, 'teacher', 'all') then '(teacher)' else ''
  getIsRead: ->
    unless @isRead
      return '(unread)'
  getUsername: ->
    Meteor.users.findOne(@senderId)?.username
  makeRead: ->
    unless @isRead
      Meteor.call('markMessagesAsRead', @senderUsername)

Template.messages.events
  'change .usernames-select': (e) ->
    Router.go('messages', { username: e.currentTarget.value })
  'submit .message-form': (e) ->
    e.preventDefault()
    unless $('.message').val()
      bootbox.alert(TAPi18n.__('Write something!'))
      return

    message = $('.message').val()
    $('.message').val('') #clear msg
    Meteor.call('sendMessage', {
      username: $('.usernames-select').val()
      sendEmail: e.target.sendEmail.checked
      message: message
    }, (err, result) ->
      if err
        console.log(err)
        $('.message').val(message)
        bootbox.alert(err.message)
    )
