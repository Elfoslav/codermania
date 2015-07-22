class @ProgrammingChallengeLessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    [
      id: '1a'
      title: TAPi18n.__ 'Star triangle'
      slug: 'star-triangle'
      template: 'starTriangle'
    ,
      id: '1b'
      title: TAPi18n.__ 'Star triangle 2'
      slug: 'star-triangle2'
      template: 'starTriangle2'
    ,
      id: '1c'
      title: TAPi18n.__ 'Star triangle 3'
      slug: 'star-triangle3'
      template: 'starTriangle3'
    ,
      id: '1d'
      title: TAPi18n.__ 'Star triangle 4'
      slug: 'star-triangle4'
      template: 'starTriangle4'
    ,
      id: '1e'
      title: TAPi18n.__ 'Symmetric star triangle'
      slug: 'symmetric-star-triangle'
      template: 'symmetricStarTriangle'
    ,
      id: '1f'
      title: TAPi18n.__ 'Star triangle 5'
      slug: 'star-triangle5'
      template: 'starTriangle5'
    ,
      id: '1g'
      title: TAPi18n.__ 'Fizz Buzz'
      slug: 'fizz-buzz'
      template: 'fizzBuzz'
    ]
    #last id 1g

  @getLesson: (number) ->
    ProgrammingChallengeLessonsList.getLessons()[number - 1]

  @getLevelNum: (lessonNum) ->
    return 1 #so far just 1 level
