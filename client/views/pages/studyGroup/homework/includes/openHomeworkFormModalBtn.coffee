Template.openHomeworkFormModalBtn.events
  'click .edit-homework-btn': (evt, tpl) ->
    $('#homework-form-modal .modal-title').text('Edit homework')
    data = Template.parentData(1)
    homework = data.homework || {}
    $('#homework-form [name="_id"]').val(homework._id)
    $('#homework-form [name="title"]').val(homework.title)
    $('#homework-form [name="type"]').val(homework.type)
    $('#homework-form [name="points"]').val(homework.points)
    $('#homework-description-textarea').code(homework.description)
  'click .create-homework-btn': (evt, tpl) ->
    $('#homework-form-modal .modal-title').text('Create homework')
    $('#homework-form')[0]?.reset()
    $('#homework-description-textarea').code('')