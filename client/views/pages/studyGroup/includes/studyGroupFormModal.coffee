processForm = (form) ->
  throw new Error('Expected form with ID study-group-form') unless form.id is 'study-group-form'
  #we would normally use $(form).serializeJSON() but inside form can be another form (in description)
  data =
    title: form.title.value
    topics: form.topics.value
    capacity: form.capacity.value
    curriculumId: form.curriculumId.value
    isPublic: form.isPublic.checked
  if isNaN data.capacity
    return bootbox.alert 'Capacity must be a number'
  if data.capacity
    data.capacity = parseInt data.capacity
  else
    data.capacity = 0
  console.log(data)
  data.description = Template.instance().$('#study-group-description-textarea').code()

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

Template.studyGroupFormModal.onCreated ->
  @subscribe('curriculums')

Template.studyGroupFormModal.onRendered ->
  @$('#study-group-description-textarea').summernote().code(@data.studyGroup?.description)

Template.studyGroupFormModal.helpers
  curriculums: ->
    StudyGroupCurriculums.find()

Template.studyGroupFormModal.events
  'submit form': (evt) ->
    evt.preventDefault()
    processForm(evt.target)
  'click #study-group-form-submit-btn': (evt) ->
    processForm(document.getElementById('study-group-form'))
  'click [href="#add-curriculum"]': (evt) ->
    $('#curriculum-form-modal input').val('')
    $('#curriculum-form-modal textarea').val('')
  'click [href="#edit-curriculum"]': (evt) ->
    curriculum = StudyGroupCurriculums.findOne($('#study-group-form [name="curriculumId"]').val())
    if curriculum
      for key, value of curriculum
        $el = $('#curriculum-form-modal [name="' + key + '"]')
        if $el[0]?.type is 'checkbox'
          $el.prop('checked', value)
        $el.val(value)
