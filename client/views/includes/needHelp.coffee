Template.needHelp.events
  'submit .need-help-form': (evt) ->
    evt.preventDefault()
    return 0 unless confirm('Are you sure you really need help? Have you read theory properly?')
    $btn = $('.need-help-form button[type="submit"]')
    if Meteor.user()
      lesson = LessonsList.getLesson(Session.get('lessonNumber'))
      lesson.url = Router.url 'lesson',
        lessonType: Lesson.getType()
        _id: lesson.id
        slug: lesson.slug
        username: Meteor.user()?.username

      lesson.type = Lesson.getType()
      lesson.code = Editor.getValue()
      $btn.attr('disabled', true)
      $btn.text(TAPi18n.__('Sending...'))
      message = evt.target.message.value
      if Session.get('activeTab') is 'exercise'
        lesson.exerciseId = Session.get('exerciseId')
      Meteor.call 'askForHelp', lesson, message, (err) ->
        if err
          bootbox.alert(err.message)
        else
          bootbox.alert(TAPi18n.__ "Our community will help you as soon as possible.
            You can continue with another lesson.
          ")
          evt.target.message.value = ''
          $btn.attr('disabled', false);
          $btn.text(TAPi18n.__('Ask for help!'))
    else
      bootbox.alert(TAPi18n.__ 'You need to be logged in if you want to ask for help.
        If you do not have an account yet, please create one. You will not regret.
      ')