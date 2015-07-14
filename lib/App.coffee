#general functionality
class @App
  @getCurrentUserId: ->
    Router.current().params.userId || Meteor.userId() || undefined

  @getCurrentUsername: ->
    user = Meteor.user()
    Router.current().params.username || user?.username || undefined

  @getCurrentUrl: ->
    if Router.current().url.indexOf('http') is -1
      url = Meteor.absoluteUrl()
      return url += Router.current().url.replace('/', '')
    return url = Router.current().url

  @getAllNeedHelpUserCommentsCount: (needHelpId, userId) ->
    NeedHelpComments.find
      needHelpId: needHelpId
      userId: { $ne: userId }
    .count()

  @getReadNeedHelpUserCommentsCount: (needHelpId, userId) ->
    NeedHelpComments.find
      needHelpId: needHelpId
      userId: { $ne: userId }
      readBy: { $in: [ userId ]}
    .count()

  @getUnreadNeedHelpUserCommentsCount: (needHelpId, userId) ->
    NeedHelpComments.find
      needHelpId: needHelpId
      userId: { $ne: userId }
      readBy: { $nin: [ userId ]}
    .count()

  @insertMessage: (opts) ->
    check opts,
      senderId: String
      senderUsername: String
      receiverId: String
      receiverUsername: String
      text: String
      needHelpId: Match.Optional String
    if opts.senderUsername == opts.receiverUsername
      throw new Meteor.Error('', 'Sender username is equal to receiver username. User cannot send message to himself.')
    Messages.insert
      senderId: opts.senderId
      senderUsername: opts.senderUsername
      receiverId: opts.receiverId
      receiverUsername: opts.receiverUsername
      text: opts.text
      timestamp: Date.now()
      isRead: false
      needHelpId: opts.needHelpId

  @getWelcomeMessage: ->
    return """
      Hello, welcome to CoderMania! I would like to hear from you:\n
      What is your experience with coding?\n
      Why do you want to learn to code?\n
      If you have any questions, you can write me here.
    """

  @getEmailFooter: ->
    """
    <p>
      Watch CoderMania on social networks:
      <a href=\"https://www.facebook.com/codermania\">Facebook</a>
      ,
      <a href=\"https://twitter.com/codermania_com\">Twitter</a>
    </p>
    <p>
      Support CoderMania on Patreon:
      <a href=\"https://www.patreon.com/elfoslav\">https://www.patreon.com/elfoslav</a>
    </p>
    <p>
      You can unsubscribe or modify your e-mail settings here:
      <a href=\"http://www.codermania.com/user/settings\">http://www.codermania.com/user/settings</a>
    </p>
    """

  @sendEmailAboutMessage: (opts) ->
    throw new Error('Cannot call from the client') unless Meteor.isServer
    sender = opts.sender
    receiver = opts.receiver
    messagesUrl = Meteor.absoluteUrl() + 'messages/' + sender.username
    msg = """
      <p>
        Hi #{receiver.username},<br><br>
        #{sender.username} has sent you a message on CoderMania.
        Go to <a href='#{messagesUrl}'>#{messagesUrl}</a> to see the message.
      </p>
    """

    console.log 'sending message from ', sender?.emails?[0]?.address
    console.log 'sending message to', receiver?.emails?[0]?.address
    console.log 'msg: ', msg
    Email.send
      from: sender?.emails?[0]?.address
      to: receiver?.emails?[0]?.address
      subject: "#{sender.username} has sent you a message on CoderMania"
      html: msg

  @evaluateOperator: (val1, operator, val2) ->
    if operator is '<'
      return val1 < val2

    if operator is '>'
      return val1 > val2

    if operator is '<='
      return val1 <= val2

    if operator is '>='
      return val1 >= val2

    if operator is '=='
      return `val1 == val2`

    if operator is '==='
      return `val1 === val2`

    if operator is '!='
      return `val1 != val2`

    if operator is '!=='
      return `val1 !== val2`

  @setPageTitle: (title) ->
    document.title = title + ' | CoderMania'
