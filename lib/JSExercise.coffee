class @JSExercise
  ###
  #  @param opts Object
  #    lesson
  #    exercise
  #    code
  #  @returns true on success, string message on failure
  ###
  @checkExercise: (opts) ->
    opts.code = $.trim(opts.code)
    exercise = opts.exercise
    lesson = opts.lesson
    success = false
    resultMsg = ''

    ######################
    # Expressions
    ######################
    if exercise.id is '1ce1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])

      line1Expected = /console\.log\( {0,1}\({0,1} {0,1}1 \+ 2 {0,1}\){0,1} < 4 {0,1}\);/

      if line1Expected.test(line1)
        success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1ce2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])

      line1Expected = /console\.log\( {0,1}\({0,1} {0,1}2 \+ 3 {0,1}\){0,1} > 5 {0,1}\);/

      if line1Expected.test(line1)
        success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1ce3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])


      line1Expected = /console\.log\( {0,1}\({0,1}5 \+ 2 {0,1}\){0,1} <= \({0,1} {0,1}14 \/ 2 {0,1}\){0,1} {0,1}\);/

      if line1Expected.test(line1)
        success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1ce4'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])

      #console.log(9 - 3 >= 2 * 3);
      #console.log((9 - 3) >= (2 * 3));
      line1Expected = /console\.log\( {0,1}\({0,1} {0,1}9 \- 3 {0,1}\){0,1} >= \({0,1} {0,1}2 \* 3 {0,1}\){0,1} {0,1}\);/

      if line1Expected.test(line1)
        success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    #############
    # Arithmetic operators
    #############
    if exercise.id is '1ie1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      if line1 is 'var i = 5;' and
        (line2 is 'i++;' or line2 is '++i;') and
        line3 is 'console.log(i);'
          success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1ie2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      if line1 is 'var i = 5;' and
        (line2 is 'i--;' or line2 is '--i;') and
        line3 is 'console.log(i);'
          success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1ie3'
      #"x % y"
      expression = extractSubstring('(', ')', $.trim(opts.code))

      #['x', 'y']
      numbers = expression.split('%')

      result = numbers[0] % numbers[1]
      if result is 2
        success = true
      else
        return resultMsg = TAPi18n.__ "Expected result is 2 but your result is #{result}"

    #######################
    # comparision operators
    #######################
    if exercise.id is '1se1'
      #"x % y"
      expression = extractSubstring('(', ')', $.trim(opts.code))

      #['x', 'y']
      numbers = expression.split('<')

      result = parseInt(numbers[0]) < parseInt(numbers[1])

      if result
        success = true
      else if result is false
        return TAPi18n.__ 'Result is false, it should be true'
      else
        return TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1se2'
      #"x % y"
      expression = extractSubstring('(', ')', $.trim(opts.code))

      #['x', 'y']
      numbers = expression.split('<=')

      result = parseInt(numbers[0]) <= parseInt(numbers[1])

      if result
        success = true
      else if result is false
        return TAPi18n.__ 'Result is false, it should be true'
      else
        return TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1se3'
      #"x % y"
      expression = extractSubstring('(', ')', $.trim(opts.code))

      #['x', 'y']
      numbers = expression.split('>=')

      result = parseInt(numbers[0]) >= parseInt(numbers[1])

      if result
        success = true
      else if result is false
        return TAPi18n.__ 'Result is false, it should be true'
      else
        return TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1se4'
      #"x % y"
      expression = extractSubstring('(', ')', $.trim(opts.code))

      #['x', 'y']
      numbers = expression.split('==')
      type1 = typeof numbers[0]
      if isNaN(parseInt(numbers[0]))
        return TAPi18n.__ "First argument should be number. #{type1} given"

      if numbers[1].indexOf("'") is -1 and numbers[1].indexOf('"') is -1
        return TAPi18n.__ "Second argument should be string. Something like '2' or \"2\""

      #strip quotes
      numbers[1] = numbers[1].replace(/[\'\"]/g, '')
      #use JS operator ==
      result = `$.trim(numbers[0]) == $.trim(numbers[1])`

      if result
        success = true
      else if result is false
        return TAPi18n.__ 'Result is false, it should be true'
      else
        return TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    ######################
    # Assignment operators
    ######################
    if exercise.id is '1je1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = 'var number = 1;'
      line2Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number", check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, print variable number with console.log(), are you missing semicolon?'

      if line1 is line1Expected and
        line2 is line2Expected
          success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1je2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = 'var number = 2;'
      line2Expected = 'number += 5;'
      line3Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number" and value 2, check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, add number 5 to variable number using operator +=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable number with console.log(), are you missing semicolon?'

      if line1 is line1Expected and
        line2 is line2Expected and
        line3 is line3Expected
          success = true
      else
        return resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    if exercise.id is '1je3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = 'var number = 3;'
      line2Expected = 'number -= 1;'
      line3Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number" and value 3, check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, subtract number 1 from variable number using operator -=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable number with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1je4'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = 'var number = 4;'
      line2Expected = 'number *= 2;'
      line3Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number" and value 4, check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, multiply variable number by 2 using operator *=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable number with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1je5'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = 'var number = 5;'
      line2Expected = 'number /= 2;'
      line3Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number" and value 4, check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, divide variable number by 2 using operator /=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable number with console.log(), are you missing semicolon?'

      success = true

    ######################
    # Assignment operators
    ######################
    if exercise.id is '1ke1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = /var someText = ['"]Lorem ipsum['"];/
      line2Expected = /someText \+= ['"] dolor sit amet['"];/
      line3Expected = 'console.log(someText);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "someText" and value "Lorem ipsum", check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, add text " dolor sit amet" to variable someText using operator +=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable someText with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1ke2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var fruit1 = ['"]apple['"];/
      line2Expected = /var fruit2 = ['"]banana['"];/
      line3Expected = /var appleAndBanana = fruit1 \+ ['"] and ['"] \+ fruit2;/
      line4Expected = 'console.log(appleAndBanana);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "fruit1" and value "apple", check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "fruit2" and value "banana", are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, read assignment on Line 3 and try again.'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, print variable appleAndBanana with console.log(), are you missing semicolon?'

      success = true

    ######################
    # Integer variables
    ######################
    if exercise.id is '1fe1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var number1 = 45;/
      line2Expected = /var number2 = 100;/
      line3Expected = /var result = number1 \+ number2;/
      line4Expected = 'console.log(result);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "number1" and value 45, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "number2" and value 100, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 2, check if variable has name "result" and value number1 + number2, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, print variable result with console.log(), are you missing semicolon?'

      success = true

    ######################
    # Float variables
    ######################
    if exercise.id is '1ge1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var number1 = 0.55;/
      line2Expected = /var number2 = 0.199;/
      line3Expected = /var result = number1 \+ number2;/
      line4Expected = 'console.log(result);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "number1" and value 0.55, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "number2" and value 0.199, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name "result" and value number1 + number2, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, print variable result with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1ge2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var number1 = 0.55;/
      line2Expected = /var number2 = 0.199;/
      line3Expected = /var result = number1 \+ number2;/
      line4Expected = 'console.log(result.toFixed(2));'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "number1" and value 0.55, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "number2" and value 0.199, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name "result" and value number1 + number2, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, round variable result to 2 decimal places and print it with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1ge3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])

      line1Expected = /var number1 = 0.55;/
      line2Expected = /var number2 = 0.199;/
      line3Expected = /var result = number1 \+ number2;/
      line4Expected = 'var roundedResult = result.toFixed(2);'
      line5Expected = 'console.log(roundedResult + 3);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "number1" and value 0.55, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "number2" and value 0.199, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name "result" and value number1 + number2, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, check if variable has name "roundedResult" and value of rounded variable "result" to 2 decimal places, are you missing semicolon?'

      if line5 != line5Expected
        return TAPi18n.__ 'Error on line 5, print roundedResult + 3 with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1ge4'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])

      line1Expected = /var number1 = 0.55;/
      line2Expected = /var number2 = 0.199;/
      line3Expected = /var result = number1 \+ number2;/
      line4Expected = 'var roundedResult = result.toFixed(2);'
      line5Expected = 'console.log(parseFloat(roundedResult) + 3);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "number1" and value 0.55, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name "number2" and value 0.199, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name "result" and value number1 + number2, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, check if variable has name "roundedResult" and value of rounded variable "result" to 2 decimal places, are you missing semicolon?'

      if line5 != line5Expected
        return TAPi18n.__ 'Error on line 5, parse value of roundedResult and add 3 to the result. Print it with console.log(), are you missing semicolon?'

      success = true

    ######################
    # Arrays
    ######################
    if exercise.id is '1le1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var numbers = \[ {0,1}\];/
      line2Expected = /numbers\.push\(1\);/
      line3Expected = /numbers\.push\(2\);/
      line4Expected = 'console.log(numbers[0]);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "numbers" and is array, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, add value 1 to variable numbers with method push(), are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, add value 2 to variable numbers with method push(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, print value 1 from array numbers with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1le2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var bands = \[ {0,1}['"]Metallica['"], ["']Iron Maiden["'] {0,1}\];/
      line2Expected = /bands\.push\('AC\/DC'\);/
      line3Expected = 'console.log(bands[0]);'
      line4Expected = 'console.log(bands[2]);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "bands" and is array and you have space after comas, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, add value \'AC/DC\' to array bands with method push(), are you missing semicolon?'

      if line3Expected != line3
        return TAPi18n.__ 'Error on line 3, print the first item from array bands with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, print the last item from array bands with console.log(), are you missing semicolon?'

      success = true

    if exercise.id is '1le3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /var numbers = \[ {0,1}5, 8, 3\.3 {0,1}\];/
      line2Expected = 'console.log(numbers[0] + numbers[1] + numbers[2]);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "numbers" and you have space after comas, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, first add number with index 0, then 1, then 2, check if you have space before and after + operator, are you missing semicolon?'

      success = true

    ######################
    # Conditions
    ######################
    if exercise.id is '1me1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var fruit = ['"]banana['"];/
      line2Expected = /if \( {0,1}fruit ={2,3} ['"]banana['"] {0,1}\) {/
      line3Expected = "console.log('variable fruit has value banana');"
      line4Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "fruit" and value \'banana\', check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition which compares variable fruit with value \'banana\', do you have space after if?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print \'variable fruit has value banana\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    if exercise.id is '1me2'
      lines = opts.code.split('\n')

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      #line 5
      unless CodeChecker.hasIndentation(lines[4])
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])
      line6 = $.trim(lines[5])

      line1Expected = /var isHappy = true;/
      #if (isHappy) {
      #or
      #if (isHappy == true) {
      line2Expected = /if \( {0,1}isHappy {0,1}(={2,3}){0,1} {0,1}(true){0,1} {0,1}\) {/
      line3Expected = /console\.log\(['"]He is happy['"]\);/
      line4Expected = '} else {'
      line5Expected = /console\.log\(['"]He is not happy['"]\);/
      line6Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "isHappy" and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition using variable isHappy, do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'He is happy\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, you do not have correct else block, check how it is written in theory'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, print \'He is not happy\' with console.log(), are you missing semicolon?'

      if line6 != line6Expected
        return TAPi18n.__ 'Error on line 6, close if condition with }'

      success = true

    if exercise.id is '1me3'
      lines = opts.code.split('\n')

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      #line 5
      unless CodeChecker.hasIndentation(lines[4])
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      #line 7
      unless CodeChecker.hasIndentation(lines[6])
        return TAPi18n.__ 'Error on line 7, you are missing indentation - tabulator or 2 spaces'

      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])
      line6 = $.trim(lines[5])
      line7 = $.trim(lines[6])
      line8 = $.trim(lines[7])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      #line 5
      unless CodeChecker.hasIndentation(lines[4])
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      #line 7
      unless CodeChecker.hasIndentation(lines[6])
        return TAPi18n.__ 'Error on line 7, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var name = ['"]Josh['"];/
      line2Expected = /if \( {0,1}name ={2,3} ['"]Peter['"] {0,1}\) {/
      line3Expected = /console\.log\(['"]Hello Peter['"]\);/
      line4Expected = /} else if \( {0,1}name ={2,3} ['"]John['"] {0,1}\) {/
      line5Expected = /console\.log\(['"]Hello John['"]\);/
      line6Expected = '} else {'
      line7Expected = /console\.log\(['"]Hello stranger['"]\);/
      line8Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name "isHappy" and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition which compares variable name with value \'Peter\', do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'Hello Peter\' with console.log(), are you missing semicolon?'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, you do not have correct else if block, check how it is written in theory'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, print \'Hello John\' with console.log(), are you missing semicolon?'

      if line6 != line6Expected
        return TAPi18n.__ 'Error on line 6, you do not have correct else block, check how it is written in theory'

      if !line7Expected.test(line7)
        return TAPi18n.__ "Error on line 7, print 'Hello stranger' with console.log(), are you missing semicolon?"

      if line8 != line8Expected
        return TAPi18n.__ 'Error on line 8, close if condition with }'

      success = true

    ######################
    # Logical operators
    ######################
    if exercise.id is '1ne1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var isHappy = true;/
      line2Expected = /if \( {0,1}!isHappy {0,1}\) {/
      line3Expected = /console\.log\(['"]He is unhappy['"]\);/
      line4Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name isHappy and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition using variable isHappy and negation operator, do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'He is unhappy\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    if exercise.id is '1ne2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])

      #line 4
      unless CodeChecker.hasIndentation(lines[3])
        return TAPi18n.__ 'Error on line 4, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var isHappy = true;/
      line2Expected = /var isHuman = true;/
      line3Expected = /if \( {0,1}isHappy && isHuman {0,1}\) {/
      line4Expected = /console\.log\(['"]Hello happy human['"]\);/
      line5Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name isHappy and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name isHuman and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, write condition with variables isHappy and isHuman using operator &&, do you have space after if?'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, print \'Hello happy human\' with console.log(), are you missing semicolon?'

      if line5 != line5Expected
        return TAPi18n.__ 'Error on line 5, close if condition with }'

      success = true

    if exercise.id is '1ne3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])

      #line 4
      unless CodeChecker.hasIndentation(lines[3])
        return TAPi18n.__ 'Error on line 4, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var isHappy = true;/
      line2Expected = /var isHuman = false;/
      line3Expected = /if \( {0,1}isHappy \|\| isHuman {0,1}\) {/
      line4Expected = /console\.log\(['"]You are happy or you are a human['"]\);/
      line5Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name isHappy and value true, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name isHuman and value false, check spaces before and after assignment operator, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, write condition with variables isHappy and isHuman using operator ||, do you have space after if?'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, print \'You are happy or you are a human\' with console.log(), are you missing semicolon?'

      if line5 != line5Expected
        return TAPi18n.__ 'Error on line 5, close if condition with }'

      success = true

    ######################
    # Truthy and valsey
    ######################
    if exercise.id is '1oe1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var truthy = (true|["'].{1,}["']|[1-9][0-9]*|\{ {0,1}\}|\[ {0,1}\]);/
      line2Expected = /if \( {0,1}truthy {0,1}(== true){0,1}\) {/
      line3Expected = /console\.log\(['"]hello truthy['"]\);/
      line4Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name truthy and truthy value, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition using variable truthy, do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'hello truthy\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    if exercise.id is '1oe2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var falsey = (false|["']["']|0|null|undefined|NaN);/
      line2Expected = /if \( {0,1}falsey {0,1}(== false){0,1}\) {/
      line3Expected = /console\.log\(['"]hello falsey['"]\);/
      line4Expected = '}'

      if !(line1 is 'var falsey;' or line1Expected.test(line1))
        return TAPi18n.__ 'Error on line 1, check if variable has name falsey and falsey value, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition using variable falsey, do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'hello falsey\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    if exercise.id is '1oe3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var falsey = (false|["']["']|0|null|undefined|NaN);/
      line2Expected = /if \( {0,1}!falsey {0,1}\) {/
      line3Expected = /console\.log\(['"]hello negated falsey['"]\);/
      line4Expected = '}'

      if !(line1 is 'var falsey;' or line1Expected.test(line1))
        return TAPi18n.__ 'Error on line 1, check if variable has name falsey and falsey value, check spaces before and after assignment operator, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, write condition using variable falsey, do you have space after if?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print \'hello falsey\' with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    ######################
    # Loops - for
    ######################
    if exercise.id is '1pe1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      #line 2
      unless CodeChecker.hasIndentation(lines[1])
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /for \(var i = 0; i (<= 4|< 5); i\+\+\) {/
      line2Expected = 'console.log(i);'
      line3Expected = '}'

      unless /i (<= 4|< 5)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad condition, the code will not run 5x'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if you have space after for keyword (for (..) {)'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, print value of variable i with console.log, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, close if condition with }'

      success = true

    if exercise.id is '1pe2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      #line 2
      unless CodeChecker.hasIndentation(lines[1])
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /for \(var i = 5; i (>= 1|> 0); i--\) {/
      line2Expected = 'console.log(i);'
      line3Expected = '}'

      unless /var i/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable does not have name i'

      unless /var i = 5/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable i has to have value 5'

      unless /i (>= 1|> 0)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad condition, the code will not run 5x'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if you have space after for keyword (for (..) {)'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, print value of variable i with console.log, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, close if condition with }'

      success = true

    if exercise.id is '1pe3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      #line 2
      unless CodeChecker.hasIndentation(lines[1])
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /for \(var i = 0; i (<= 21|<= 20|< 21|< 22); (i \+= 2|i = i \+ 2)\) {/
      line2Expected = 'console.log(i);'
      line3Expected = '}'

      unless /var i/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable does not have name i'

      unless /var i = 0/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable i has to have value 0'

      unless /i (<= 21|<= 20|< 21|< 22)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad condition, the loop will not end at 20'

      unless /(i \+= 2|i = i \+ 2)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad iteration step, you need to increment i by 2'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if you have space after for keyword (for (..) {)'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, print value of variable i with console.log, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, close if condition with }'

      success = true

    if exercise.id is '1pe4'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      #line 2
      unless CodeChecker.hasIndentation(lines[1])
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /for \(var i = 1; i (<= 19|<= 20|< 20|< 21); (i \+= 2|i = i \+ 2)\) {/
      line2Expected = 'console.log(i);'
      line3Expected = '}'

      unless /var i/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable does not have name i'

      unless /var i = 1/.test(line1)
        return TAPi18n.__ 'Error on line 1, iteration variable i has to have value 1'

      unless /i (<= 19|<= 20|< 20|< 21)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad condition, the loop will not end at 19'

      unless /(i \+= 2|i = i \+ 2)/.test(line1)
        return TAPi18n.__ 'Error on line 1, bad iteration step, you need to increment i by 2'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if you have space after for keyword (for (..) {)'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, print value of variable i with console.log, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, close if condition with }'

      success = true

    if exercise.id is '1pe5'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      #line 3
      unless CodeChecker.hasIndentation(lines[2])
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /var bands = \[ {0,1}['"]Metallica['"], ['"]AC\/DC['"], ['"]Iron Maiden['"] {0,1}\]/
      line2Expected = /for \(var i = 0; i (<= bands\.length - 1|< bands\.length); i\+\+\) {/
      line3Expected = /console\.log\(bands\[i\]\);/
      line4Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, read assignment for line 1 and try again. Do you have space and comma between array items? Are you missing semicolon?'

      unless /var i/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable does not have name i'

      unless /var i = 0/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable i has to have value 0'

      unless /i (<= bands\.length - 1|< bands\.length)/.test(line2)
        return TAPi18n.__ 'Error on line 2, bad condition, the loop will not end at last array item'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, bad for loop. Read assignment for line 2 and try again.'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print items from array bands with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      success = true

    ######################
    # Functions
    ######################
    if exercise.id is '1qe1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = lines[1]
      line3 = lines[2]
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /function printNameAndAge\(name, age\) {/
      line2Expected = /console\.log\(['"]Hi ['"] \+ name\);/
      line3Expected = /console\.log\(['"]You are ['"] \+ age \+ ['"] years old['"]\);/
      line4Expected = '}'
      line5Expected = /printNameAndAge\(["']Tom['"], 28\);/

      unless /name/.test(line1)
        return TAPi18n.__ 'Error on line 1, parameter "name" is missing'
      unless /age/.test(line1)
        return TAPi18n.__ 'Error on line 1, parameter "age" is missing'
      unless /printNameAndAge/.test(line1)
        return TAPi18n.__ 'Error on line 1, function does not have name printNameAndAge'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if your code is according to conventions'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, read assignment for line 2 and try again, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, read assignment for line 3 and try again, are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close if condition with }'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, read assignment for line 5 and try again, are you missing semicolon?'

      success = true

    if exercise.id is '1qe2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = lines[1]
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /function multiply\(a, b\) {/
      line2Expected = /return a \* b;/
      line3Expected = '}'
      line4Expected = /console.log\( {0,1}multiply\(5, 2\) {0,1}\);/

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, define function with name multiply and parameters a and b'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, return a * b from function multiply, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, close if condition with }'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, read assignment for line 4 and try again, are you missing semicolon?'

      success = true

    if exercise.id is '1qe3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = lines[1]
      line3 = lines[2]
      line4 = $.trim(lines[3])
      line5 = $.trim(lines[4])
      line6 = $.trim(lines[5])

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3, 4)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(lines[3])
        return TAPi18n.__ 'Error on line 4, you are missing indentation - tabulator or 2 spaces'

      line1Expected = /function printArray\(arr\) {/
      line2Expected = /for \(var i = 0; (i < arr\.length|i <= arr\.length - 1); i\+\+\) {/
      line3Expected = /console\.log\( {0,1}arr\[i\]\ {0,1}\);/
      line4Expected = '}'
      line5Expected = '}'
      line6Expected = /printArray\(\[5, 10, 15\]\);/

      unless /printArray/.test(line1)
        return TAPi18n.__ 'Error on line 1, function does not have name printArray'

      unless /var i/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable must have name i'

      unless /var i = 0/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable must have value 0, check if your code is according to conventions'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if your code is according to conventions'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, define for loop, check if your code is according to conventions, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print item from array with console.log(), are you missing semicolon?'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close loop with }'

      if line5 != line5Expected
        return TAPi18n.__ 'Error on line 5, close function with }'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, call function printArray with parameter [5, 10, 15], are you missing semicolon?'

      success = true

    ######################
    # Objects
    ######################
    if exercise.id is '1re1'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0]); line2 = lines[1]; line3 = lines[2]
      line4 = lines[3]; line5 = lines[4]; line6 = lines[5]
      line7 = lines[6]; line8 = lines[7]; line9 = lines[8]
      line10 = lines[9]; line11 = lines[10]; line12 = lines[11]
      line13 = lines[12]

      line1Expected = /var car = {/
      line2Expected = /name: ["'].+['"],/
      line3Expected = /speed: \d+,/
      line4Expected = /accelerate: function\(\) {/
      line5Expected = /(this\.speed\+\+|\+\+this\.speed|this\.speed = this\.speed \+ 1|this\.speed = 1 \+ this\.speed|this\.speed \+= 1);/
      line6Expected = /},/
      line7Expected = /toString: function\(\) {/
      line8Expected = /return ["']Car ["'] \+ this\.name \+ ["'] has speed ['"] \+ this\.speed;/
      line9Expected = /}/
      line10Expected = /};/
      line11Expected = /console\.log\( {0,1}car\.toString\(\) {0,1}\);/
      line12Expected = /car\.accelerate\(\);/
      line13Expected = /console\.log\( {0,1}car\.toString\(\) {0,1}\);/

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line4)
        return TAPi18n.__ 'Error on line 4, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line5, 4)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line6)
        return TAPi18n.__ 'Error on line 6, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line7)
        return TAPi18n.__ 'Error on line 8, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line8)
        return TAPi18n.__ 'Error on line 8, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line9)
        return TAPi18n.__ 'Error on line 9, you are missing indentation - tabulator or 2 spaces'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name car'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if property has name <i>name</i> and its value is string, are you missing comma?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if property has name <i>speed</i> and its value is integer, are you missing comma?'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, check if method has name <i>accelerate</i>'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, are you sure you are increasing speed property? Are you missing semicolon?'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, close <i>accelerate</i> method with },'

      if !line7Expected.test(line7)
        return TAPi18n.__ 'Error on line 7, check if method has name <i>toString</i>'

      if !line8Expected.test(line8)
        return TAPi18n.__ 'Error on line 8, read what <i>toString</i> should return and try again, are you missing semicolon?'

      if !line9Expected.test(line9)
        return TAPi18n.__ 'Error on line 9, close <i>toString</i> method with }'

      if !line10Expected.test(line10)
        return TAPi18n.__ 'Error on line 10, close object with };, are you missing semicolon?'

      if !line11Expected.test(line11)
        return TAPi18n.__ 'Error on line 11, read assignment for line 11 and try again, are you missing semicolon?'

      if !line12Expected.test(line12)
        return TAPi18n.__ 'Error on line 12, read assignment for line 12 and try again, are you missing semicolon?'

      if !line13Expected.test(line13)
        return TAPi18n.__ 'Error on line 13, read assignment for line 13 and try again, are you missing semicolon?'

      success = true

    if exercise.id is '1re2'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0]); line2 = lines[1]; line3 = lines[2]
      line4 = lines[3]; line5 = lines[4]; line6 = lines[5]

      line1Expected = /var person = {/
      line2Expected = /name: ["'].+['"]/
      line3Expected = /};/
      line4Expected = /console\.log\(person\.name\);/
      line5Expected = /person\.name = ["'].+['"];/
      line6Expected = /console\.log\(person\.name\);/

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name person'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if property has name <i>name</i> and its value is string, are you missing comma?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, close object with };'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, read assignment for line 4 and try again, are you missing semicolon?'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, read assignment for line 5 and try again, are you missing semicolon?'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, read assignment for line 6 and try again, are you missing semicolon?'

      success = true

    if exercise.id is '1re3'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0]); line2 = lines[1]; line3 = lines[2]
      line4 = lines[3]; line5 = lines[4]; line6 = lines[5]
      line7 = lines[6]; line8 = lines[7];

      line1Expected = /var dog = {/
      line2Expected = /name: ["'].+['"],/
      line3Expected = /bark: function\(\) {/
      line4Expected = /console\.log\(["']wof wof["']\);/
      line5Expected = /}/
      line6Expected = /};/
      line7Expected = /console\.log\(dog\.name\);/
      line8Expected = /dog\.bark\(\);/

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line4, 4)
        return TAPi18n.__ 'Error on line 4, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line5)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name dog'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if property has name <i>name</i> and its value is string, are you missing comma?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, define method with name <i>bark</i>'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, print "wof wof" with console.log(), are you missing semicolon?'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, close method with }'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, close object with };'

      if !line7Expected.test(line7)
        return TAPi18n.__ 'Error on line 7, print name of the dog with console.log()'

      if !line8Expected.test(line8)
        return TAPi18n.__ 'Error on line 8, call method bark(), are you missing semicolon?'

      success = true

    if exercise.id is '1re4'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0]); line2 = lines[1]; line3 = lines[2]
      line4 = lines[3]; line5 = lines[4]; line6 = lines[5]
      line7 = lines[6]; line8 = lines[7]; line9 = lines[8]

      line1Expected = /var Dog = function\(name\) {/
      line2Expected = /this\.name = name;/
      line3Expected = /this\.bark = function\(\) {/
      line4Expected = /console\.log\(["']wof wof["']\);/
      line5Expected = /};/
      line6Expected = /}/
      line7Expected = /var dog = new Dog\(["'].+['"]\);/
      line8Expected = /console\.log\(dog\.name\);/
      line9Expected = /dog\.bark\(\);/

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line4, 4)
        return TAPi18n.__ 'Error on line 4, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line5)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name dog'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if property has name <i>name</i> and its value is parameter <i>name</i>, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, define method with name <i>bark</i>'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, print "wof wof" with console.log(), are you missing semicolon?'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, close method with };'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, close object definition with }'

      if !line7Expected.test(line7)
        return TAPi18n.__ 'Error on line 7, read assignment for line 7 and try again'

      if !line8Expected.test(line8)
        return TAPi18n.__ 'Error on line 8, print name of the dog with console.log()'

      if !line9Expected.test(line9)
        return TAPi18n.__ 'Error on line 9, call method bark(), are you missing semicolon?'

      success = true

    unless resultMsg or success
      resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    return resultMsg || success
