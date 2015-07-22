class @CSSLessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    [
      id: '1a'
      title: TAPi18n.__ 'Hello world!'
      slug: 'hello-world'
      template: 'CSSHelloWorld'
      hasTheory: true
    ,
      id: '1b'
      title: TAPi18n.__ 'Syntax'
      slug: 'syntax'
      template: 'CSSSyntax'
      hasTheory: true
    ,
      id: '1c'
      title: TAPi18n.__ 'Selectors'
      slug: 'selectors'
      template: 'CSSSelectors'
      hasTheory: true
    ,
      id: '1d'
      title: TAPi18n.__ 'Inline styles'
      slug: 'inline-styles'
      template: 'CSSInlineStyles'
      hasTheory: true
    ,
      id: '1e'
      title: TAPi18n.__ 'Global styles'
      slug: 'global-styles'
      template: 'CSSGlobalStyles'
      hasTheory: true
    ,
      id: '1f'
      title: TAPi18n.__ 'External styles'
      slug: 'external-styles'
      template: 'CSSExternalStyles'
      hasTheory: true
    ]
    #last id 1f

  @getLesson: (number) ->
    @getLessons()[number - 1]

  @getLevelNum: (lessonNum) ->
    return 1 #so far just 1 level