Accounts.config
  sendVerificationEmail: true
  loginExpirationInDays: null

Accounts.onCreateUser (options, user) ->
  if options.profile
    user.profile = options.profile

  if user.username == 'elfoslav'
    #teacher in group all
    user.roles = {
      'all': [ 'teacher', 'admin' ]
    }
  else
    user.roles = {
      'all': [ 'student' ]
    }

  elfoslav = Meteor.users.findOne({ username: 'elfoslav' })
  unless Messages.findOne({ receiverId: user._id })
    if Messages.findOne({ receiverUsername: user.username })
      Logger.log "Welcome message for user #{user.username} with id #{user._id} already exists", 'warning'
    else
      App.insertMessage
        senderId: elfoslav._id
        senderUsername: elfoslav.username
        receiverId: user._id
        receiverUsername: user.username
        text: App.getWelcomeMessage()
      user.welcomeMessageSent = true

  return user
