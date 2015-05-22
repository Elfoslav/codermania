Template.code.helpers
  htmlCode: ->
    Code.findOne({ type: 'html' })?.code
  jsCode: ->
    Code.findOne({ type: 'js' })?.code

Template.code.events
  'keyup .html-code-form textarea': (evt, tpl) ->
    code = evt.target.value
    Meteor.call 'saveHtmlCode', code, (err) ->
      console.log err if err
  'submit .html-code-form': (evt, tpl) ->
    evt.preventDefault()
    code = evt.target.code.value
    Meteor.call 'saveHtmlCode', code, (err) ->
      console.log err if err

  'keyup .js-code-form textarea': (evt, tpl) ->
    code = evt.target.value
    Meteor.call 'saveJsCode', code, (err) ->
      console.log err if err
  'submit .js-code-form': (evt, tpl) ->
    evt.preventDefault()
    code = evt.target.code.value
    Meteor.call 'saveJsCode', code, (err) ->
      console.log err if err