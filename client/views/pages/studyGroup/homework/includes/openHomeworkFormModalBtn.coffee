Template.openHomeworkFormModalBtn.events
  'click .edit-homework-btn': (evt, tpl) ->
    $('#homework-form-modal .modal-title').text('Edit homework')
  'click .create-homework-btn': (evt, tpl) ->
    $('#homework-form-modal .modal-title').text('Create homework')
    $('#homework-form')[0]?.reset()