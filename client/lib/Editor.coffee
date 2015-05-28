class @Editor
  @getEditor: ->
    ace.edit('editor')

  @getValue: ->
    Editor.getEditor().getValue()

  @highlightOutput: ->
    hljs.highlightBlock($('.output')[0])

  @setValue: (val) ->
    editor = ace.edit('editor')
    editor.setValue(val)
    editor.selection.clearSelection()

  @evaluate: ->
    editor = ace.edit('editor')
    $('.output').text('')
    code = editor.getValue()
    code = code.replace(/console.log/g, 'document.write');
    #eval might throw an exception
    eval code

  @highlightCodeInText: (type) ->
    type = type || 'js'
    $('.code-in-text').each (index, item) ->
      $(item).addClass(type)
      if !$(item).hasClass('hljs')
        hljs.highlightBlock(item);

  @removeHighlight: (code) ->
    $codeInText = $('.code-in-text')
    $codeInText.removeClass().addClass('code-in-text')
    $codeInText.each (index, item) ->
      $(item).text(code || $(item).text())
