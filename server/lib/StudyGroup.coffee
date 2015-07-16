class @StudyGroup
  @getUnreadMessagesCount: (data) ->
    check data,
      userId: String
      studyGroupId: String
    return StudyGroupMessages.find
      studyGroupId: data.studyGroupId
      isReadBy: $nin: [ data.userId ]
    .count()

  @getUserStudyGroups: (userId) ->
    check userId, String
    return StudyGroups.find
      userIds: $in: [ userId ]

  #Send e-mail notifications for all users
  @sendUnreadMessagesEmailNotifications: (frequency) ->
    #weekly frequency is default, user settings does not need to exist
    if frequency is 'weekly'
      query =
        $or: [
          { 'settings.emailNotifications': frequency }
          { 'settings.emailNotifications': $exists: 0 }
        ]
    else
      query = { 'settings.emailNotifications.studyGroupNotifications': frequency }

    users = Meteor.users.find query,
      fields:
        _id: 1
        'settings.emailNotifications': 1
        emails: 1

    userEmails = []
    Logger.log 'sending study group notifications, found ' + users.count() + ' users'
    users.forEach (user) ->
      userStudyGroups = StudyGroup.getUserStudyGroups user._id
      totalUnreadMessagesCount = 0
      userStudyGroups.forEach (group) ->
        totalUnreadMessagesCount += StudyGroup.getUnreadMessagesCount
          userId: user._id
          studyGroupId: group._id

      if totalUnreadMessagesCount > 0 and
        user.settings?.emailNotifications?.studyGroupNotifications != 'turn-off'
          userEmails.push user.emails?[0]?.address

    if userEmails.length > 0
      Logger.log 'sending study group notifications to ' + userEmails.length + ' users'
      Email.send
        from: 'info@codermania.com'
        bcc: userEmails
        subject: "Study group notifications"
        html: """
          Hi coder,<br/><br/>

          you have unread messages in your study groups. Read them on:
          <a href=\"http://www.codermania.com/study-groups\">http://www.codermania.com/study-groups</a>
          <br/><br/>
          #{App.getEmailFooter({ showUnsubscribe: true })}
        """
