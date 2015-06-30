class @JSLesson
  ###
  #  @param opts Object
  #    lesson
  #    code
  #  @returns true on success, string message on failure
  ###
  @checkAssignment: (opts) ->
    opts.code = $.trim(opts.code)
    lesson = opts.lesson
    success = false
    resultMsg = ''

    #hello world
    if lesson.id is '1a'
      if opts.code == "console.log('Hello world')"
        resultMsg = TAPi18n.__ 'Missing semicolon!'
      if opts.code != "console.log('Hello world');"
        resultMsg = TAPi18n.__ 'Your code contains something wrong.
          The code must look exactly like in assignment.
          Check it and try again!'
      if opts.code == "console.log('Hello world');"
        success = true

    #statements
    if lesson.id is '1y'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /console\.log\(["']statement 1["']\);/
      line2Expected = /console\.log\(["']statement 2["']\);/

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, read assignment for line 1 and try again, are you missing semicolon?'
      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, read assignment for line 2 and try again, are you missing semicolon?'

      success = true

    #comments
    if lesson.id is '1b'
      line5 = opts.code.split('\n')[4]
      #matches "//console.log('Comment this line');"
      if line5 and /\/\/.*console\.log\('Comment this line'\);/.test(line5)
        success = true
      else
        resultMsg = TAPi18n.__ 'comment out code on line 5'

    #expressions
    if lesson.id is '1c'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])

      line1Expected = /console\.log\( {0,1}\({0,1} {0,1}8 \+ 2 {0,1}\){0,1} <= 11 {0,1}\);/

      if line1Expected.test(line1)
        success = true

    #variables intro
    if lesson.id is '1d'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /var emptyVariable;/
      line2Expected = /console\.log\(emptyVariable\);/

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name emptyVariable, are you missing semicolon?'
      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, print variable emptyVariable with console.log, are you missing semicolon?'

      success = true

    #conventions
    if lesson.id is '1u'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = "var message = 'Conventions are good for you';"
      line2Expected = 'console.log(1 + 2);'
      line3Expected = 'console.log(4 <= 5);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, do you have space before and after operator = ?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, do you have space before and after operator + ?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, do you have space before and after operator <= ?'

      success = true

    #arithmetic operators
    if lesson.id is '1i'
      if opts.code[opts.code.length - 1] != ';'
        return TAPi18n.__('Missing semicolon')

      #"x % y"
      expression = extractSubstring('(', ')', opts.code)

      #['x', 'y']
      numbers = expression.split('%')

      result = numbers[0] % numbers[1]
      if result is 3
        success = true
      else
        resultMsg = TAPi18n.__('Result should be 3. Your result is') + ' ' + result

    #comparison operators
    if lesson.id is '1s'
      lines = opts.code.split('\n')
      if $.trim(lines[1])[$.trim(lines[1]).length - 1] != ';' or
        $.trim(lines[2])[$.trim(lines[2]).length - 1] != ';' or
        $.trim(lines[3])[$.trim(lines[3]).length - 1] != ';'
          return TAPi18n.__('Missing semicolon')

      expr1 = extractSubstring('(', ')', $.trim(lines[1]))
      expr2 = extractSubstring('(', ')', $.trim(lines[2]))
      expr3 = extractSubstring('(', ')', $.trim(lines[3]))

      expr1Arr = expr1.split(' ')
      unless App.evaluateOperator(parseInt(expr1Arr[0]), expr1Arr[1], parseInt(expr1Arr[2]))
        return TAPi18n.__ 'Expression %s is false', 1

      expr2Arr = expr2.split(' ')

      if expr2Arr[0]?.indexOf('\'') != -1 or expr2Arr[0]?.indexOf('"') != -1
        num1 = expr2Arr[0].replace(/"/g, '')
      else
        num1 = parseInt(expr2Arr[0])

      if expr2Arr[2]?.indexOf('\'') != -1 or expr2Arr[2]?.indexOf('"') != -1
        num2 = expr2Arr[2].replace(/"/g, '')
      else
        num2 = parseInt(expr2Arr[2])

      unless App.evaluateOperator(num1, expr2Arr[1], num2)
        return TAPi18n.__ 'Expression %s is false', 2

      expr3Arr = expr3.split(' ')
      unless App.evaluateOperator(parseInt(expr3Arr[0]), expr3Arr[1], expr3Arr[2].replace(/"/g, ''))
        return TAPi18n.__ 'Expression %s is false', 3

      return true

    #########
    # Level 2
    #########

    #assignment operators
    if lesson.id is '1j'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = 'var number = 5;'
      line2Expected = 'number *= 2;'
      line3Expected = 'console.log(number);'

      if line1 != line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name "number" and value 5, check spaces before and after assignment operator, are you missing semicolon?'

      if line2 != line2Expected
        return TAPi18n.__ 'Error on line 2, multiply variable number by 2 using operator *=, are you missing semicolon?'

      if line3 != line3Expected
        return TAPi18n.__ 'Error on line 3, print variable number with console.log(), are you missing semicolon?'

      success = true

    #string variables
    if lesson.id is '1e'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /var name = ['"](.)+['"];/
      line2Expected = 'console.log(name);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name name and value is your name as string'

      if line2 isnt line2Expected
        return TAPi18n.__ 'Error on line 2, read assignment for line 2 and try again.'

      if line1Expected.test(line1) and line2 is line2Expected
        success = true
      else if line1[line1.length - 1] != ';'
        resultMsg = TAPi18n.__ 'Missing semicolon on line 1'

    #string operators
    if lesson.id is '1k'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      line1Expected = /var text = ['"]Hello {0,1}['"];/
      line2Expected = /text \+= ['"] {0,1}world['"];/
      line3Expected = 'console.log(text);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name text and value \'Hello\''

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, read assignment for line 2 and try again.'

      if line3 isnt line3Expected
        return TAPi18n.__ 'Error on line 3, print variable text with console.log()'

      success = true

    #integer variables
    if lesson.id is '1f'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = /var x = \d+;/
      line2Expected = /var y = \d+;/
      line3Expected = /var z = \d+;/
      line4Expected = 'console.log(x * y + z);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name x and arbitrary integer value, are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, check if variable has name y and arbitrary integer value, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name z and arbitrary integer value, are you missing semicolon?'

      if line4 isnt line4Expected
        return TAPi18n.__ 'Error on line 4, print x * y + z with console.log()'

      success = true

    #float variables
    if lesson.id is '1g'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])

      line1Expected = 'var pi = 3.14;'
      line2Expected = 'var r = 5;'
      line3Expected = /var circumference = \({0,1}2 \* pi \* r\){0,1};/
      line4Expected = 'console.log(circumference);'

      if line1 isnt line1Expected
        return TAPi18n.__ 'Error on line 1, check if variable has name pi and value 3.14, are you missing semicolon?'

      if line2 isnt line2Expected
        return TAPi18n.__ 'Error on line 2, check if variable has name r and value 5, are you missing semicolon?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, check if variable has name circumference and value 2 * pi * r, are you missing semicolon?'

      if line4 isnt line4Expected
        return TAPi18n.__ 'Error on line 4, print variable circumference with console.log()'

      success = true

    #boolean variables
    if lesson.id is '1h'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /var isCoderMan = (true|false|.+ ={2,3} .+|.+ <= .+|.+ >= .+);/
      line2Expected = 'console.log(isCoderMan);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name isCoderMan and boolean value, are you missing semicolon?'

      if line2 isnt line2Expected
        return TAPi18n.__ 'Error on line 2, print variable isCoderMan with console.log(), are you missing semicolon?'

      success = true

    #arrays
    if lesson.id is '1l'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])

      line1Expected = /var fruits = \[\s{0,1}'apple', 'orange', 'banana'\s{0,1}\];/
      line2Expected = 'console.log(fruits[1]);'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name fruits. Do you have comma and space after each value? Are you missing semicolon?'

      if line2 isnt line2Expected
        return TAPi18n.__ 'Error on line 2, read assignment for line 2 and try again. Are you missing semicolon?'

      success = true

    #conditions
    if lesson.id is '1m'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = lines[2]
      line4 = $.trim(lines[3])
      line5 = lines[4]
      line6 = $.trim(lines[5])

      line1Expected = /var age = \d+;/
      line2Expected = /if \(age >= 18\) {/
      line3Expected = /console\.log\(["']You are an adult["']\);/
      line4Expected = /} else {/
      line5Expected = /console\.log\(["']You are a child["']\);/
      line6Expected = /}/

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if variable has name age and value is your age (number). Are you missing semicolon?'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, Write if condition, compare if variable age is greater than or equal to 18'

      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, write \'You are an adult\' with console.log()'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, write proper else block. After { must be space. After else must be space and {'

      unless CodeChecker.hasIndentation(line5)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, write \'You are a child\' with console.log()'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, end block else with curly bracket.'

      success = true

    #switch
    if lesson.id is '1v'
      lines = opts.code.split('\n')
      line5 = lines[4]
      line8 = lines[7]
      line11 = lines[10]

      if line5.indexOf('break;') == -1
        return TAPi18n.__ 'Add break command after the first case'

      if line8.indexOf('break;') == -1
        return TAPi18n.__ 'Add break command after the second case'

      if line11.indexOf('break;') == -1
        return TAPi18n.__ 'Add break command after the third case'

      if line5.indexOf('break;') != -1 and
        line8.indexOf('break;') != -1 and
        line11.indexOf('break;') != -1
          success = true

    #logical operators
    if lesson.id is '1n'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = $.trim(lines[2])

      if (line1 == 'var isPokemon = false;' and
        line2 == 'var isPikachu = true;' and
        line3 == "if (isPokemon || isPikachu) {") or
        (line1 == 'var isPokemon = true;' and
        line2 == 'var isPikachu = true;' and
        line3 == "if (isPokemon || isPikachu) {") or
        (line1 == 'var isPokemon = true;' and
        line2 == 'var isPikachu = false;' and
        line3 == "if (isPokemon || isPikachu) {") or
        (line1 == 'var isPokemon = true;' and
        line2 == 'var isPikachu = true;' and
        line3 == "if (isPokemon && isPikachu) {")
          success = true

    #falsey and truthy
    if lesson.id is '1o'
      lines = opts.code.split('\n')
      line2 = $.trim(lines[1])

      if line2 is 'var falseyVar;' or
        (/var falseyVar = {0,1}(0|null|''|undefined|false|NaN);/).test(line2)
          success = true

    #loops
    if lesson.id is '1p'
      lines = opts.code.split('\n')
      line1 = $.trim(lines[0])
      line2 = $.trim(lines[1])
      line3 = lines[2]
      line4 = $.trim(lines[3])

      line1Expected = /var fruits = \[ {0,1}['"]orange['"], ['"]banana['"], ['"]pear['"] {0,1}\]/
      line2Expected = /for \(var i = 0; i (<= fruits\.length - 1|< fruits\.length); i\+\+\) {/
      line3Expected = /console\.log\(fruits\[i\]\);/
      line4Expected = '}'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, read assignment for line 1 and try again. Do you have space and comma between array items? Are you missing semicolon?'

      unless /var i/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable does not have name i'

      unless /var i = 0/.test(line2)
        return TAPi18n.__ 'Error on line 2, iteration variable i has to have value 0'

      unless /i (<= fruits\.length - 1|< fruits\.length)/.test(line2)
        return TAPi18n.__ 'Error on line 2, bad condition, the loop will not end at last array item'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, bad for loop. Read assignment for line 2 and try again.'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, print items from array fruits with console.log(), are you missing semicolon?'

      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'

      if line4 != line4Expected
        return TAPi18n.__ 'Error on line 4, close loop with }'

      success = true

    #loops - while
    if lesson.id is '1t'
      lines = opts.code.split('\n')
      line3 = $.trim(lines[2])
      line4 = $.trim(lines[3])
      line5 = lines[4]
      line6 = lines[5]
      line7 = $.trim(lines[6])

      line3Expected = /var i = 0;/
      line4Expected = /while \(i (< fruits\.length|<= fruits\.length - 1)\) {/
      line5Expected = /console\.log\(fruits\[i\]\);/
      line6Expected = /(i\+\+|\+\+i|i \+= 1|i = i \+ 1);/
      line7Expected = '}'

      unless /var i/.test(line3)
        return TAPi18n.__ 'Error on line 3, define iteration variable with name i'

      unless /var i = 0/.test(line3)
        return TAPi18n.__ 'Error on line 3, iteration variable i has to have value 0'

      unless /i (<= fruits\.length - 1|< fruits\.length)/.test(line4)
        return TAPi18n.__ 'Error on line 4, bad condition, the loop will not end at last array item'

      if !line3Expected.test(line3)
        return TAPi18n.__ "Error on line 3, do you have iteration variable on line 3? Are you missing semicolon?"

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, bad while condition, write while condition according to conventions'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, print items from fruits array with console.log()'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, increment iteration variable, are you missing semicolon?'

      if line7 != line7Expected
        return TAPi18n.__ 'Error on line 7, close loop with }'

      success = true

    #Functions
    if lesson.id is '1q'
      lines = opts.code.split('\n')
      line1 = lines[0]; line2 = lines[1]; line3 = lines[2]; line4 = lines[3]
      line5 = lines[4]; line6 = lines[5]; line7 = lines[6]; line8 = lines[7]

      line1Expected = /function sum\(numbers\) {/
      line2Expected = /^var \w+ = 0;$/
      line3Expected = /for \(var i = 0; (i < numbers.length|i <= numbers.length - 1); i\+\+\) {/
      line4Expected = /(\w+ = (numbers\[ {0,1}i {0,1}\] \+ \w+|\w+ \+ numbers\[ {0,1}i {0,1}\])|\w+ \+= numbers\[ {0,1}i {0,1}\]);/
      line5Expected = /}/
      line6Expected = /return \w+;/
      line7Expected = /}/
      line8Expected = /console\.log\(sum\(\[2, 3, 6\]\)\);/

      unless /\(numbers\)/.test(line1)
        return TAPi18n.__ 'Error on line 1, check if your function parameter is called numbers'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, bad definition of the function sum, check if your code is according to conventions'

      if !line2Expected.test($.trim(line2))
        return TAPi18n.__ 'Error on line 2, define a variable with arbitrary name and value 0, you will use this variable for computing and returning summary'

      unless /var i/.test(line3)
        return TAPi18n.__ 'Error on line 3, iteration variable does not have name i'

      unless /var i = 0/.test(line3)
        return TAPi18n.__ 'Error on line 3, iteration variable i has to have value 0'

      unless /i (<= numbers\.length - 1|< numbers\.length)/.test(line3)
        return TAPi18n.__ 'Error on line 3, bad condition in for loop, are you using numbers array and length property?'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, bad for loop, check if your loop is according to conventions'

      if !line4Expected.test(line4)
        return TAPi18n.__ """Error on line 4, add current array item to your summary variable, you can use operator +=\n
          Read the assignment again properly"""

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, close for loop with }'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, return you summary variable'

      if !line7Expected.test(line7)
        return TAPi18n.__ 'Error on line 7, close function with }'

      if !line8Expected.test(line8)
        return TAPi18n.__ 'Error on line 8, Call the function <i>sum</i> with parameter <b>[2, 3, 6]</b> and print the result with console.log()'

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line4, 4)
        return TAPi18n.__ 'Error on line 4, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line5)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line6)
        return TAPi18n.__ 'Error on line 6, you are missing indentation - tabulator or 2 spaces'

      success = true

    #Objects
    if lesson.id is '1r'
      lines = opts.code.split('\n')
      line1 = lines[0]; line2 = lines[1]; line3 = lines[2]; line4 = lines[3]
      line5 = lines[4]; line6 = lines[5]; line7 = lines[6]; line8 = lines[7]
      line9 = lines[8]; line10 = lines[9]

      line1Expected = /function Person\(name, age\) {/
      line2Expected = /this\.name = name;/
      line3Expected = /this\.age = age;/
      line4Expected = /this\.sayHello = function\(\) {/
      line5Expected = /console\.log\(['"]Hello, my name is ["'] \+ this\.name\);/
      line6Expected = /console\.log\(['"]And my age is ['"] \+ this\.age\);/
      line7Expected = /}/
      line8Expected = /}/
      line9Expected = /var peter = new Person\(["']Peter['"], 31\);/
      line10Expected = /peter\.sayHello\(\);/

      unless CodeChecker.hasIndentation(line2)
        return TAPi18n.__ 'Error on line 2, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line3)
        return TAPi18n.__ 'Error on line 3, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line4)
        return TAPi18n.__ 'Error on line 4, you are missing indentation - tabulator or 2 spaces'
      unless CodeChecker.hasIndentation(line5, 4)
        return TAPi18n.__ 'Error on line 5, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line6, 4)
        return TAPi18n.__ 'Error on line 6, you are missing indentation - 2x tabulator or 4 spaces'
      unless CodeChecker.hasIndentation(line7)
        return TAPi18n.__ 'Error on line 7, you are missing indentation - tabulator or 2 spaces'

      if !line1Expected.test(line1)
        return TAPi18n.__ 'Error on line 1, check if function has name <i>Person</i> and parameters <i>name</i> and <i>age</i>'

      if !line2Expected.test(line2)
        return TAPi18n.__ 'Error on line 2, assign parameter <i>name</i> to object property <i>name</i>'

      if !line3Expected.test(line3)
        return TAPi18n.__ 'Error on line 3, assign parameter <i>age</i> to object property <i>age</i>'

      if !line4Expected.test(line4)
        return TAPi18n.__ 'Error on line 4, define method <i>sayHello</i>'

      if !line5Expected.test(line5)
        return TAPi18n.__ 'Error on line 5, read assignment for line 5 and try again'

      if !line6Expected.test(line6)
        return TAPi18n.__ 'Error on line 6, read assignment for line 6 and try again'

      if !line7Expected.test(line7)
        return TAPi18n.__ 'Error on line 7, close method with }'

      if !line8Expected.test(line8)
        return TAPi18n.__ 'Error on line 8, close function with }'

      if !line9Expected.test(line9)
        return TAPi18n.__ 'Error on line 9, read assignment for line 9 and try again'

      if !line10Expected.test(line10)
        return TAPi18n.__ 'Error on line 10, read assignment for line 10 and try again'

      success = true

    unless resultMsg or success
      resultMsg = TAPi18n.__ 'Read assignment and try again, you can ask for help if you are lost'

    return resultMsg || success