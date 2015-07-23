Template.messages.onRendered ->
  Meteor.typeahead.inject()
  #we also set username in route, just for sure ;-)
  $('.message-form .typeahead').val(Router.current()?.params.username)

Template.messages.helpers
  usernames: ->
    usernames = Meteor.users.find({
      username: { $ne: Meteor.user()?.username }
    })
    .fetch()
    .map((user) ->
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
  searchUsernames: (query, sync, callback) ->
    Meteor.call 'searchUsernames', query, {}, (err, res) ->
      return console.log err if err
      callback res.map (user) ->
        { value: user.username }

Template.messages.events
  'typeahead:selected, typeahead:autocompleted, typeahead:change': (e) ->
    Router.go('messages', { username: e.currentTarget.value })
  'submit .message-form': (e) ->
    e.preventDefault()
    msgInput = e.target.message
    unless msgInput.value
      bootbox.alert(TAPi18n.__('Write something!'))
      return

    username = e.target.username.value
    message = msgInput.value
    msgInput.value = ''
    $('.message-form .btn[type="submit"]').text('Sending...').attr('disabled', true)
    Meteor.call 'sendMessage',
      username: username
      sendEmail: e.target.sendEmail.checked
      message: message
    , (err, result) ->
      if err
        console.log(err)
        msgInput.value = message
        bootbox.alert(err.message)
      $('.message-form .btn[type="submit"]').text('Send').attr('disabled', false)
