class @WebDeveloperLessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    [
      id: '1a'
      title: TAPi18n.__ 'Hello world!'
      slug: 'hello-world'
      template: 'webDeveloperHelloWorld'
      hasTheory: true
    ,
      id: '1b'
      title: TAPi18n.__ 'Processing forms'
      slug: 'head'
      template: 'webDeveloperProcessingForms'
      hasTheory: true
    ]
    #last id 1b

  @getLesson: (number) ->
    WebDeveloperLessonsList.getLessons()[number - 1]

  @getLevelNum: (lessonNum) ->
    return 1 #so far just 1 level
