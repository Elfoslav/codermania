processForm = (form) ->
  throw new Error('Expected form with ID study-group-form') unless form.id is 'study-group-form'
  data = $(form).serializeJSON()
  console.log 'data.isPublic: ', data.isPublic
  data.isPublic = data.isPublic == 'on' or !!data.isPublic
  if isNaN data.capacity
    return bootbox.alert 'Capacity must be a number'
  if data.capacity
    data.capacity = parseInt data.capacity
  else
    data.capacity = 0
  console.log(data)

  route = Router.current()
  if route.route.getName() is 'studyGroup' and route.params._id
    data._id = route.params._id
    Meteor.call 'editStudyGroup', data, (err, result) ->
      if err
        bootbox.alert err.message
        console.log err
      else
        $('#study-group-modal').modal('hide')
  else
    Meteor.call 'createStudyGroup', data, (err, result) ->
      if err
        bootbox.alert err.message
        console.log err
      else
        $('#study-group-modal').modal('hide')
        $("#study-group-modal input[type=text]").val('')
        $('#study-group-modal textarea').val('')

Template.studyGroupFormModal.events
  'submit form': (evt) ->
    evt.preventDefault()
    processForm(evt.target)
  'click #study-group-form-submit-btn': (evt) ->
    processForm(document.getElementById('study-group-form'))