class @JSLessonsList
  @_collection = new Mongo.Collection(null)
  @getLessons: ->
    [
      id: '1a'
      title: TAPi18n.__ 'Hello world!'
      slug: 'hello-world'
      template: 'helloWorld'
      hasTheory: true
    ,
      id: '1y'
      title: TAPi18n.__ 'Statements'
      slug: 'statements'
      hasTheory: true
    ,
      id: '1b'
      title: TAPi18n.__ 'Comments'
      slug: 'comments'
      hasTheory: true
      initCode: """
        //#{TAPi18n.__ 'this is one line comment'}. #{TAPi18n.__ 'Code in this line will not be processed'}
        /* #{TAPi18n.__ 'this'}
        #{TAPi18n.__ 'is multiline comment'}
        #{TAPi18n.__ 'this will not be processed'} */
        console.log('#{TAPi18n.__('Comment this line')}');
      """
    ,
      id: '1u'
      title: TAPi18n.__ 'Coding conventions'
      slug: 'coding-conventions'
      template: 'codingConventions'
      hasTheory: true
      initAssignmentCode: """
        var message= 'Conventions are good for you';
        console.log(1+2);
        console.log(4<= 5);
      """
    ,
      id: '1c'
      title: TAPi18n.__ 'Expressions'
      slug: 'expressions'
      template: 'expressionsPart1'
      hasTheory: true
      hasExercise: true
      exercises:
        '1ce1':
          id: '1ce1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1ce2':
          id: '1ce2'
          title: TAPi18n.__ 'Exercise 2'
        '1ce3':
          id: '1ce3'
          title: TAPi18n.__ 'Exercise 3'
        '1ce4':
          id: '1ce4'
          title: TAPi18n.__ 'Exercise 4'
    ,
      id: '1d'
      title: TAPi18n.__ 'Variables - introduction'
      slug: 'variables-introduction'
      template: 'variablesIntroduction'
      hasTheory: true
    ,
      id: '1i'
      title: TAPi18n.__ 'Arithmetic Operators'
      slug: 'arithmetic-operators'
      template: 'arithmeticOperators'
      hasTheory: true
      hasExercise: true
      exercises:
        '1ie1':
          id: '1ie1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1ie2':
          id: '1ie2'
          title: TAPi18n.__ 'Exercise 2'
        '1ie3':
          id: '1ie3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1s'
      title: TAPi18n.__ 'Comparison Operators'
      slug: 'comparison-operators'
      template: 'comparisonOperators'
      hasTheory: true
      hasExercise: true
      initAssignmentCode: """
        //#{TAPi18n.__('Following expressions must be evaluated to true')}
        console.log(42 < 5);
        console.log(6 === \"6\");
        console.log(1 != \"1\");
      """
      exercises:
        '1se1':
          id: '1se1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1se2':
          id: '1se2'
          title: TAPi18n.__ 'Exercise 2'
        '1se3':
          id: '1se3'
          title: TAPi18n.__ 'Exercise 3'
        '1se4':
          id: '1se4'
          title: TAPi18n.__ 'Exercise 4'
    ,
      id: '1j'
      title: TAPi18n.__ 'Assignment Operators'
      slug: 'assignment-operators'
      template: 'assignmentOperators'
      hasTheory: true
      hasExercise: true
      exercises:
        '1je1':
          id: '1je1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1je2':
          id: '1je2'
          title: TAPi18n.__ 'Exercise 2'
        '1je3':
          id: '1je3'
          title: TAPi18n.__ 'Exercise 3'
        '1je4':
          id: '1je4'
          title: TAPi18n.__ 'Exercise 4'
        '1je5':
          id: '1je5'
          title: TAPi18n.__ 'Exercise 5'
    ,
      id: '1e'
      title: TAPi18n.__ 'String Variables'
      slug: 'string-variables'
      template: 'stringVariables'
      hasTheory: true
    ,
      id: '1k'
      title: TAPi18n.__ 'String Operators'
      slug: 'string-operators'
      template: 'stringOperators'
      hasTheory: true
      hasExercise: true
      exercises:
        '1ke1':
          id: '1ke1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1ke2':
          id: '1ke2'
          title: TAPi18n.__ 'Exercise 2'
    ,
      id: '1f'
      title: TAPi18n.__ 'Integer Variables'
      slug: 'integer-variables'
      template: 'integerVariables'
      hasTheory: true
      hasExercise: true
      exercises:
        '1fe1':
          id: '1fe1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
    ,
      id: '1g'
      title: TAPi18n.__ 'Float Variables'
      slug: 'float-variables'
      template: 'floatVariables'
      hasTheory: true
      hasExercise: true
      exercises:
        '1ge1':
          id: '1ge1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1ge2':
          id: '1ge2'
          title: TAPi18n.__ 'Exercise 2'
        '1ge3':
          id: '1ge3'
          title: TAPi18n.__ 'Exercise 3'
        '1ge4':
          id: '1ge4'
          title: TAPi18n.__ 'Exercise 4'
    ,
      id: '1h'
      title: TAPi18n.__ 'Boolean variables'
      slug: 'boolean-variables'
      template: 'booleanVariables'
      hasTheory: true
    ,
      id: '1l'
      title: TAPi18n.__ 'Arrays'
      slug: 'arrays'
      hasTheory: true
      hasExercise: true
      exercises:
        '1le1':
          id: '1le1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1le2':
          id: '1le2'
          title: TAPi18n.__ 'Exercise 2'
        '1le3':
          id: '1le3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1m'
      title: TAPi18n.__ 'Conditions'
      slug: 'conditions'
      hasTheory: true
      hasExercise: true
      exercises:
        '1me1':
          id: '1me1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1me2':
          id: '1me2'
          title: TAPi18n.__ 'Exercise 2'
        '1me3':
          id: '1me3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1v'
      title: TAPi18n.__ 'Switch'
      slug: 'switch'
      hasTheory: true
      initCode: ""
      initAssignmentCode: """
        var letter = 'b';
        switch (letter) {
          case 'a':
            console.log('letter \"a\"');
          case 'b':
            console.log('letter \"b\"');
          case 'c':
            console.log('letter \"c\"');
          default:
            console.log('Unknown letter');
        }
      """
    ,
      id: '1n'
      title: TAPi18n.__ 'Logical operators'
      slug: 'logical-operators'
      template: 'logicalOperators'
      hasTheory: true
      hasExercise: true
      initAssignmentCode: """
        var isPokemon = false;
        var isPikachu = true;
        if (isPokemon && isPikachu) {
          console.log('Pika pika... Pikachu!');
        }
      """
      exercises:
        '1ne1':
          id: '1ne1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1ne2':
          id: '1ne2'
          title: TAPi18n.__ 'Exercise 2'
        '1ne3':
          id: '1ne3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1o'
      title: TAPi18n.__ 'Falsey and truthy'
      template: 'falseyAndTruthyValues'
      slug: 'falsey-and-truthy-values'
      hasTheory: true
      hasExercise: true
      initAssignmentCode: """
        //#{TAPi18n.__('define falseyVar under this line')}:

        if (!falseyVar) {
          console.log('You understand falsey values');
        }
      """
      exercises:
        '1oe1':
          id: '1oe1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1oe2':
          id: '1oe2'
          title: TAPi18n.__ 'Exercise 2'
        '1oe3':
          id: '1oe3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1p'
      title: TAPi18n.__ 'Loops - for'
      slug: 'loops'
      template: 'loops'
      hasTheory: true
      hasExercise: true
      exercises:
        '1pe1':
          id: '1pe1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1pe2':
          id: '1pe2'
          title: TAPi18n.__ 'Exercise 2'
        '1pe3':
          id: '1pe3'
          title: TAPi18n.__ 'Exercise 3'
        '1pe4':
          id: '1pe4'
          title: TAPi18n.__ 'Exercise 4'
        '1pe5':
          id: '1pe5'
          title: TAPi18n.__ 'Exercise 5'
    ,
      id: '1t'
      title: TAPi18n.__ 'Loops - while'
      slug: 'loops-while'
      template: 'loopsWhile'
      hasTheory: true
      hasExercise: true
      initAssignmentCode: """
        var fruits = ['orange', 'banana', 'pear'];
        //Do not delete this line... write while loop under this line:
      """
    ,
      id: '1q'
      title: TAPi18n.__ 'Functions'
      slug: 'functions'
      hasTheory: true
      hasExercise: true
      exercises:
        '1qe1':
          id: '1qe1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1qe2':
          id: '1qe2'
          title: TAPi18n.__ 'Exercise 2'
        '1qe3':
          id: '1qe3'
          title: TAPi18n.__ 'Exercise 3'
    ,
      id: '1r'
      title: TAPi18n.__ 'Objects'
      slug: 'objects'
      hasTheory: true
      hasExercise: true
      exercises:
        '1re1':
          id: '1re1'
          title: TAPi18n.__ 'Exercise 1'
          expand: true
        '1re2':
          id: '1re2'
          title: TAPi18n.__ 'Exercise 2'
        '1re3':
          id: '1re3'
          title: TAPi18n.__ 'Exercise 3'
        '1re4':
          id: '1re4'
          title: TAPi18n.__ 'Exercise 4'
    ,
      id: '1x'
      title: TAPi18n.__ 'Errors and Try/Catch'
      slug: 'errors-and-try-catch'
      template: 'errorsAndTryCatch'
      hasTheory: true
      hasExercise: true
    ]
    #last id 1y

  @getLesson: (number) ->
    JSLessonsList.getLessons()[number - 1]

  #@number - lesson number
  @getFirstExercise: (number) ->
    lesson = LessonsList.getLesson(number)
    return lesson.exercises?[lesson.id + 'e1']

  @getCurrentExerciseNumber: ->
    exerciseId = Session.get('exerciseId')
    if exerciseId
      return parseInt exerciseId[exerciseId.length - 1]
    return 0

  @getNextExerciseId: (exerciseId) ->
    lesson = LessonsList.getLesson(Session.get 'lessonNumber')
    exerciseNum = parseInt exerciseId[exerciseId.length - 1]
    nextExerciseId = lesson.id + 'e' + (exerciseNum + 1)
