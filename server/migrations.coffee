Meteor.startup ->
  Migrations = new Mongo.Collection('migrations')

  migration1Name = 'send welcome message'
  unless Migrations.findOne { name: migration1Name }
    elfoslav = Meteor.users.findOne({ username: 'elfoslav' })
    users = Meteor.users.find
      $or: [
        { points: { $exists: false } }
        { points: { $lt: 200 } }
      ]
      welcomeMessageSent: { $ne: true }
    console.log 'sending welcome message to ' + users.count() + ' users.'
    users.forEach (user) ->
      userMsg = Messages.findOne
        $or: [
          { senderId: user._id }
          { receiverId: user._id }
        ]
      #send only if user does not have messages yet
      unless userMsg
        App.insertMessage
          senderId: elfoslav._id
          senderUsername: elfoslav.username
          receiverId: user._id
          receiverUsername: user.username
          text: App.getWelcomeMessage()
        Meteor.users.update user._id,
          $set:
            welcomeMessageSent: true
        App.sendEmailAboutMessage
          sender: elfoslav
          receiver: user
        Logger.log('sending welcome message to ' + user.username)

    Migrations.insert
      name: migration1Name
