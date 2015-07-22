class @HTMLLessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    [
      id: '1a'
      title: TAPi18n.__ 'Hello world!'
      slug: 'hello-world'
      template: 'HTMLHelloWorld'
      hasTheory: true
    ,
      id: '1b'
      title: TAPi18n.__ 'Head'
      slug: 'head'
      template: 'HTMLHead'
      hasTheory: true
    ,
      id: '1c'
      title: TAPi18n.__ 'Body'
      slug: 'body'
      template: 'HTMLBody'
      hasTheory: true
    ,
      id: '1d'
      title: TAPi18n.__ 'Tags'
      slug: 'tags'
      template: 'HTMLTags'
      hasTheory: true
    ,
      id: '1e'
      title: TAPi18n.__ 'Attributes'
      slug: 'attributes'
      template: 'HTMLAttributes'
      hasTheory: true
    ]
    #last id 1e

  @getLesson: (number) ->
    HTMLLessonsList.getLessons()[number - 1]

  @getLevelNum: (lessonNum) ->
    return 1 #so far just 1 level
