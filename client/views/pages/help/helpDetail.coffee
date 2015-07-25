Template.helpDetail.onRendered ->
  this.renderedCounter = 0
  this.autorun =>
    #just find need help to trigger autorun
    needHelp = NeedHelp.findOne()
    if NeedHelp.find().count() is 1 and this.renderedCounter > 0
      Meteor.setTimeout =>
        Editor.removeHighlight()
        $('.code-in-text').first().text(needHelp.lessonCode)
        Editor.highlightCodeInText()
      , 2
    this.renderedCounter++

Template.helpDetail.helpers
  getAssignmentTemplate: ->
    needHelp = Template.instance().data?.needHelp
    lesson = needHelp.lesson
    lessonTemplateName = (lesson.template || lesson.title.toLowerCase()) + 'Assignment'
    return needHelp.exerciseId || lessonTemplateName
  getRouteName: ->
    needHelp = Template.instance().data?.needHelp
    if needHelp.lessonType is 'programming-challenge'
      return 'lessonProgrammingChallenge'
    else if needHelp.lessonType is 'html'
      return 'lessonHTML'
    else if needHelp.lessonType is 'css'
      return 'lessonCSS'
    else
      return 'lessonJS'
  isUnreadByUser: (needHelpUserId) ->
    NeedHelpComments.findOne
      _id: @_id
      userId: { $ne: needHelpUserId }
      readBy: { $nin: [ needHelpUserId ]}
  makeCommentRead: (needHelpId, needHelpUserId) ->
    if @readBy and needHelpUserId is Meteor.userId() and @readBy.indexOf(needHelpUserId) is - 1
      Meteor.call('setNeedHelpCommentsRead', needHelpId)
  isNeedHelpUser: ->
    @needHelp.username is Meteor.user()?.username

Template.helpDetail.events
  'submit .comment-form': (evt) ->
    evt.preventDefault()
    msg = evt.target.text.value
    evt.target.text.value = ''
    lang = TAPi18n.getLanguage()
    unless $.trim(msg)
      return bootbox.alert(TAPi18n.__('Write something!'))
    opts =
      needHelpId: @needHelp._id
      lesson: @needHelp.lesson
      sendEmail: evt.target.sendEmail?.checked || false
      msg: msg
      url: App.getCurrentUrl()
      lang: lang
    Meteor.call 'saveNeedHelpComment', opts, (err, result) ->
      if err
        bootbox.alert("Error: #{err.message}")
        console.log err
        evt.target.text.value = msg

  'click .mark-need-help-solved': (evt) ->
    evt.preventDefault()
    Meteor.call('markNeedHelpSolved', @needHelp._id)

  'click .mark-need-help-unsolved': (evt) ->
    evt.preventDefault()
    Meteor.call('markNeedHelpUnsolved', @needHelp._id)
