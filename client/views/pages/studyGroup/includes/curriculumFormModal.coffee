processForm = (form) ->
  throw new Error('Expected form with ID study-group-form') unless form.id is 'study-group-form'
  data = $(form).serializeJSON()

  Meteor.call 'addOrEditCurriculum', data, (err, result) ->
    if err
      bootbox.alert err.message
      console.log err
    else
      $('#curriculum-form-modal').modal('hide')
      $("#curriculum-form input[type=text]").val('')
      $('#curriculum-form textarea').val('')

Template.curriculumFormModal.events
  'submit #curriculum-form': (evt) ->
    evt.preventDefault()
    processForm(evt.target)
  'click #curriculum-form-submit-btn': (evt) ->
    processForm(document.getElementById('curriculum-form'))
