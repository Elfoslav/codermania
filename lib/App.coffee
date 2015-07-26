#general functionality
class @App
  @initTextEditor: (selector) ->
    if Meteor.isClient
      #editor docs: http://www.tinymce.com
      #destroy the old one editor, in order to get new working
      tinymce.get()?[0]?.destroy()
      editor = tinymce.init
        selector: selector
        plugins: [
            "advlist autolink lists link image charmap print preview hr anchor pagebreak",
            "visualblocks visualchars code fullscreen",
            "insertdatetime media nonbreaking save contextmenu directionality",
            "template paste textpattern imagetools"
        ]
        toolbar: "undo redo | bold italic | bullist numlist outdent indent | link image | preview fullpage"

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

  ###
  #@params {
  #  studyGroupId: String
  #  homeworkId: String
  #  username: String
  #}
  ###
  @getStudyGroupHomeworkUrl: (params) ->
    "#{Meteor.absoluteUrl()}study-groups/#{params.studyGroupId}/homework/#{params.homeworkId}/#{params.username}"

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

    existingSendersList = SendersList.findOne({ senderId: opts.senderId, receiverId: opts.receiverId })
    if existingSendersList
      SendersList.update { senderId: opts.senderId, receiverId: opts.receiverId },
        $set:
          lastMsgTimestamp: Date.now()
          senderUsername: opts.senderUsername #just in case
        $inc: { unreadMsgsCount: 1 }
    else
      SendersList.insert
        senderId: opts.senderId
        senderUsername: opts.senderUsername
        receiverId: opts.receiverId
        lastMsgTimestamp: Date.now()
        unreadMsgsCount: 1

  @getWelcomeMessage: ->
    return """
      Hello, welcome to CoderMania! I would like to hear from you:\n
      What is your experience with coding?\n
      Why do you want to learn to code?\n
      If you have any questions, you can write me here.
    """

  @getEmailFooter: (opts) ->
    msg = "
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
    "
    if opts.showUnsubscribe
      msg += "
        <p>
          You can unsubscribe or modify your e-mail settings here:
          <a href=\"http://www.codermania.com/user/settings\">http://www.codermania.com/user/settings</a>
        </p>
      "
    return msg

  @getClientErrorMessage: (err) ->
    """Something went wrong, please try again.
    If you see this message again, please contact CoderMania admin: <b>tomas@codermania.com</b>
    and tell him what does not work. Thanks.
    <br><br>
    Error: #{err.reason}"""

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
      <br>
      #{@getEmailFooter({ showUnsubscribe: false })}
    """

    Email.send
      from: sender?.emails?[0]?.address
      to: receiver?.emails?[0]?.address
      subject: "#{sender.username} has sent you a message on CoderMania"
      html: msg

  @sendEmailAboutHomeworkComment: (opts) ->
    throw new Error('Cannot call from the client') unless Meteor.isServer
    sender = opts.sender
    receiver = opts.receiver
    msg = """
      <p>
        Hi #{receiver.username},<br><br>
        #{sender.username} commented your homework on CoderMania.
      </p>
      <p>
        Go to <a href='#{opts.homeworkUrl}'>#{opts.homeworkUrl}</a> to see the message.
      </p>
      <br>
      #{@getEmailFooter({ showUnsubscribe: false })}
    """

    Email.send
      from: sender?.emails?[0]?.address
      to: receiver?.emails?[0]?.address
      subject: "#{sender.username} commented your homework on CoderMania"
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
