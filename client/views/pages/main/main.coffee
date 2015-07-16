Template.main.helpers
  config: ->
    return (editor) ->
      # Set some reasonable options on the editor
      editor.setTheme('ace/theme/monokai')
      editor.setFontSize('1.2em');
      editor.getSession().setMode('ace/mode/javascript')
      editor.setShowPrintMargin(false)
      editor.getSession().setUseWrapMode(true)
      editor.getSession().setTabSize(2);
      Editor.setValue("""
        console.log('#{TAPi18n.__('Hello stranger')}');
        console.log('#{TAPi18n.__('Welcome to CoderMania')}');
        console.log('#{TAPi18n.__('You will learn to code here')}');
      """)

Template.main.events(
  'click .sign-up-btn': (e) ->
    e.preventDefault()
    Meteor.setTimeout(->
      $('#login-dropdown-list a.dropdown-toggle').trigger('click')
      $('#login-dropdown-list .dropdown-menu').addClass('tada')
      $('#login-dropdown-list #signup-link').trigger('click')
    , 5)
)