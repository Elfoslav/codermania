Template.codeInText.events({
  'click .copy-code': (e) ->
    e.preventDefault()
    Editor.setValue($(e.currentTarget).prev().text())
    Editor.highlightOutput()
    try
      Editor.evaluate()
    catch e
      console.log(e)
      $('.output').html(e.message)
})