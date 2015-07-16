evaluate = (code) ->
  newIframe = document.getElementById('homework-iframe') || document.createElement('iframe')
  newIframe.frameBorder = 0
  newIframe.width = '100%'
  newIframe.height = '300'
  newIframe.id = 'homework-iframe'
  newIframe.src = 'data:text/html;charset=utf-8,' + encodeURI(code)
  homeworkResult = document.getElementById('homework-result')
  if homeworkResult.childNodes[0]
    homeworkResult.removeChild homeworkResult.childNodes[0]
  homeworkResult.appendChild(newIframe)

initSummernoteEditor = ->
  #summernote docs: http://summernote.org/#/deep-dive
  $('#homework-comments-textarea').summernote
    height: 150
    toolbar: [
      #['style', ['style']], // no style button
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['insert', ['picture', 'link']],
      ['help', ['help']]
      ['fullscreen', ['fullscreen']]
      ['codeview', ['codeview']]
    ]

Template.studyGroupHomework.onRendered ->
  initSummernoteEditor()

Template.studyGroupHomework.helpers
  editorConfig: ->
    return (editor) ->
      editor.setTheme('ace/theme/monokai')
      editor.getSession().setMode('ace/mode/html')
      editor.setShowPrintMargin(false)
      editor.getSession().setUseWrapMode(true)
      editor.getSession().setTabSize(2);

      hw = Homework.findOne Router.current().params.homeworkId
      studentHomework = StudentHomework.findOne()
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
    !@studentHomework?.success and Router.current().params.username == Meteor.user()?.username
  isHomeworkUser: ->
    @studentHomework?.userId == Meteor.userId()
  makeReadComment: ->
    studentHw = StudentHomework.findOne @studentHomeworkId
    if !@isRead and studentHw?.userId == Meteor.userId()
      Meteor.call 'makeReadStudentHomeworkComments', @studentHomeworkId

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
          initSummernoteEditor()
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
        Alerts.set('Successfuly submitted', 'success')
        setTimeout ->
          initSummernoteEditor()
        , 100
  'click .run-the-code': (evt, tpl) ->
    evt.preventDefault()
    console.log 'Run the code'
    evaluate(ace.edit('html-editor').getValue())
  'submit .comment-form': (evt, tpl) ->
    evt.preventDefault()
    textarea = $('#homework-comments-textarea')
    data =
      message: textarea.code()
      studentHomeworkId: tpl.data.studentHomework?._id
    Meteor.call 'saveStudentHomeworkComment', data, (err) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        textarea.code('Write a comment')
