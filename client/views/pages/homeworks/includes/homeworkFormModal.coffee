processForm = (form) ->
  data = $(form).serializeJSON()
  data.description = $('#homework-description-textarea').summernote().code()
  if Router.current().route.getName() == 'studyGroup'
    studyGroupId = Router.current().params._id
  console.log data, studyGroupId
  Meteor.call 'createHomework', data, studyGroupId, (err, result) ->
    if err
      bootbox.alert err.reason
      console.log err
    else
      $('#homework-form-modal').modal('hide')

Template.homeworkFormModal.onRendered ->
  @$('#homework-description-textarea').summernote().code(@data.homework?.description)

Template.homeworkFormModal.events
  'submit #homework-form': (evt, tpl) ->
    evt.preventDefault()
    processForm(document.getElementById('homework-form'))
  'click #homework-form-submit-btn': (evt) ->
    processForm(document.getElementById('homework-form'))
