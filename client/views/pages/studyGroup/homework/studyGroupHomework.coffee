evaluate = (code) ->
  newIframe = document.getElementById('homework-iframe') || document.createElement('iframe')
  code = code.replace(/(<\/head>)/, "<base target=\"_parent\" />$1")
  newIframe.frameBorder = 0
  newIframe.width = '100%'
  newIframe.height = '300'
  newIframe.allowfullscreen = 'true'
  newIframe.webkitallowfullscreen = 'true'
  newIframe.name = 'homework-result-iframe'
  newIframe.id = 'homework-iframe'
  newIframe.srcdoc = code #srcdoc does not have problem with content origin policy
  #newIframe.src = 'data:text/html;charset=utf-8,' + encodeURI(code)
  homeworkResult = document.getElementById('homework-result')
  if homeworkResult.childNodes[0]
    homeworkResult.removeChild homeworkResult.childNodes[0]
  homeworkResult.appendChild(newIframe)

initTextEditor = ->
  #editor docs: https://www.froala.com/wysiwyg-editor/docs/
  $editor = $('#homework-comments-textarea').editable
    inlineMode: false
    buttons: [
      'bold', 'italic', 'underline', 'formatBlock', 'insertOrderedList',
      'insertUnorderedList', 'outdent', 'indent', 'undo', 'redo', 'html'
    ]

Template.studyGroupHomework.onRendered ->
  initTextEditor()

Template.studyGroupHomework.helpers
  editorConfig: ->
    hw = Template.instance().data.homework
    studentHomework = Template.instance().data.studentHomework
    return (editor) ->
      editor.setTheme('ace/theme/monokai')
      editor.getSession().setMode('ace/mode/html')
      editor.setShowPrintMargin(false)
      editor.getSession().setUseWrapMode(true)
      editor.getSession().setTabSize(2);

      if studentHomework
        editor.setValue studentHomework.code
      else
        editor.setValue """
          <!DOCTYPE html>
          <html>
            <head>
              <title>#{hw.title}</title>
            </head>
            <body>
              Do your homework here
            </body>
          </html>
        """
      editor.selection.clearSelection()
  isCurrent: ->
    Router.current().params.homeworkId is @_id
  showSaveAndSubmitButtons: ->
    return false unless Meteor.user()
    !@studentHomework?.success and Router.current().params.username == Meteor.user()?.username
  isCurrentUserInGroup: ->
    @studyGroup?.userIds?.indexOf(Meteor.userId()) != -1
  isHomeworkUser: ->
    @studentHomework?.userId == Meteor.userId()
  makeReadComment: ->
    Meteor.call 'makeReadStudentHomeworkComments', @studentHomeworkId
  isCorrect: ->
    StudentHomework.findOne({ homeworkId: @_id })?.success
  canMarkAsCorrect: ->
    (@studentHomework and Meteor.user()?.username is 'elfoslav') or
      (@studentHomework and Meteor.userId() != @studentHomework.userId)

Template.studyGroupHomework.events
  'click .mark-as-correct': (evt, tpl) ->
    evt.preventDefault()
    data =
      homeworkId: tpl.data.homework?._id
      username: Router.current().params.username
    Meteor.call 'markHomeworkAsCorrect', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
  'click .mark-as-incorrect': (evt, tpl) ->
    evt.preventDefault()
    data =
      homeworkId: tpl.data.homework?._id
      username: Router.current().params.username
    Meteor.call 'markHomeworkAsIncorrect', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
  'click .save-and-run': (evt, tpl) ->
    evt.preventDefault()
    data =
      studyGroupId: tpl.data.studyGroup?._id
      homeworkId: tpl.data.homework?._id
      code: ace.edit('html-editor').getValue()
    evaluate(data.code)
    Meteor.call 'saveStudentHomework', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        Alerts.set('Successfuly saved', 'success')
        setTimeout ->
          initTextEditor()
        , 100
  'click .submit-to-teacher': (evt, tpl) ->
    evt.preventDefault()
    data =
      studyGroupId: tpl.data.studyGroup?._id
      homeworkId: tpl.data.homework?._id
      code: ace.edit('html-editor').getValue()
    evaluate(data.code)
    Meteor.call 'submitStudentHomework', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        bootbox.alert('Successfuly submitted. Your teacher will review your homework soon.')
        setTimeout ->
          initTextEditor()
        , 100
  'click .run-the-code': (evt, tpl) ->
    evt.preventDefault()
    evaluate(ace.edit('html-editor').getValue())
  'submit .comment-form': (evt, tpl) ->
    evt.preventDefault()
    form = evt.target
    $textarea = $('#homework-comments-textarea')
    data =
      message: $textarea.editable('getHTML')
      studentHomeworkId: tpl.data.studentHomework?._id
    if form.sendEmail
      data.sendEmail = form.sendEmail.checked
    Meteor.call 'saveStudentHomeworkComment', data, (err) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        $textarea.editable('setHTML', '')
        form.reset()
  'click .enter-fullscreen-btn': (evt, tpl) ->
    evt.preventDefault()
    fullscreenHw = document.getElementById('fullscreen-homework')
    if BigScreen.enabled
      BigScreen.toggle fullscreenHw, ->
        console.log('fulllscreen enabled')
        $(fullscreenHw).addClass('fullscreen-enabled')
        $(fullscreenHw).find('.col-sm-4').removeClass('col-sm-4').addClass('col-sm-7')
        tpl.$('#homework-comments').addClass('hidden')
        $('.enter-fullscreen-btn').text('Exit fullscreen')
      , ->
        console.log('leaving fullscreen')
        $(fullscreenHw).removeClass('fullscreen-enabled')
        $(fullscreenHw).find('.col-sm-7').removeClass('col-sm-7').addClass('col-sm-4')
        tpl.$('#homework-comments').removeClass('hidden')
        $('.enter-fullscreen-btn').text('Enter fullscreen')
