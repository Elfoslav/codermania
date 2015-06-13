processForm = (form) ->
  unless form.id is 'curriculum-form'
    throw new Error('Expected form with ID curriculum-form. ' + form?.id + ' given')
  data = $(form).serializeJSON()
  studyGroupId = Router.current().params._id

  Meteor.call 'addOrEditCurriculum', data, studyGroupId, (err, result) ->
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
