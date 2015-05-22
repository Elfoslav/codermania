describe "Lesson.checkAssignment", ->
  #arithmetic operators
  Meteor.startup ->
    Meteor.setTimeout(

      describe 'Statements', ->
        lesson = JSLessonsList._collection.findOne({id: '1y'})

        it "should return true for correct code", ->
          code = """
            console.log('statement 1');
            console.log(\"statement 2\");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Expressions', ->
        lesson = JSLessonsList._collection.findOne({id: '1c'})

        it "should return true for correct code", ->
          code = """
            console.log(8 + 2 <= 11);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            console.log( (8 + 2) <= 11 );
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Variables introduction', ->
        lesson = JSLessonsList._collection.findOne({id: '1d'})

        it "should return true for correct code", ->
          code = """
            var emptyVariable;
            console.log(emptyVariable);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return false for incorrect code 1", ->
          code = """
            var emptyVariable = 'lol';
            console.log(emptyVariable);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

        it "should return false for incorrect code 2", ->
          code = """
            var emptyVariable;
            console.log(emptyVariable)
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

        it "should return false for incorrect code 3", ->
          code = """
            var emptyVariable
            console.log(emptyVariable);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

      describe 'Coding conventions', ->
        lesson = JSLessonsList._collection.findOne({id: '1u'})

        it "should return true for correct code", ->
          code = """
            var message = 'Conventions are good for you';
            console.log(1 + 2);
            console.log(4 <= 5);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return false for incorrect code", ->
          code = """
            var message= 'Conventions are good for you';
            console.log(1+2);
            console.log(4<= 5);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

      describe 'arithmetic operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1i'})

        it "should not return true for code console.log(5 % 3);", ->
          code = """
            console.log(5 % 3);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toEqual('Result should be 3. Your result is 2')

        it "should not return true for code console.log(11 % 3)", ->
          code = """
            console.log(11 % 3)
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toEqual('Missing semicolon')

        it "should return true for code console.log(11 % 4);", ->
          code = """
            console.log(11 % 4);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Comparison operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1s'})

        it "should not return true - missing semicolon", ->
          code = """
            //Following expressions must be evaluated to true
            console.log(42 < 5)
            console.log(6 === "6");
            console.log(1 != "1");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

        it "should return true for correct code 1", ->
          code = """
            //Following expressions must be evaluated to true
            console.log(42 > 5);
            console.log(6 == "6");
            console.log(1 == "1");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            //Following expressions must be evaluated to true
            console.log(42 > 5);
            console.log(6 !== "6");
            console.log(1 !== "1");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 3", ->
          code = """
            //Following expressions must be evaluated to true
            console.log(42 > 5);
            console.log(6 == "6");
            console.log(1 !== "1");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 4", ->
          code = """
            //Following expressions must be evaluated to true
            console.log(42 > 5);
            console.log(6 !== "6");
            console.log(1 == "1");
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Assignment operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1j'})

        it "should return true for correct code", ->
          code = """
            var number = 5;
            number *= 2;
            console.log(number);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'String variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1e'})

        it "should return true for correct code", ->
          code = """
            var name = 'Josh';
            console.log(name);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)


      describe 'Integer variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1f'})

        it "should return true for correct code", ->
          code = """
            var x = 5123;
            var y = 6;
            var z = 10;
            console.log(x * y + z);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'String operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1k'})

        it "should return true for correct code", ->
          code = """
            var text = 'Hello';
            text += ' world';
            console.log(text);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Float variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1g'})

        it "should return true for correct code", ->
          code = """
            var pi = 3.14;
            var r = 5;
            var circumference = 2 * pi * r;
            console.log(circumference);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Boolean variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1h'})

        it "should return true for correct code 1", ->
          code = """
            var isCoderMan = false;
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            var isCoderMan = true;
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 3", ->
          code = """
            var isCoderMan = 20 == 30;
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 4", ->
          code = """
            var isCoderMan = 20 === 30;
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 5", ->
          code = """
            var isCoderMan = 20 <= 30;
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should NOT return true for incorrect code", ->
          code = """
            var isCoderMan = '';
            console.log(isCoderMan);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

      describe 'Arrays', ->
        lesson = JSLessonsList._collection.findOne({id: '1l'})

        it "should return true for correct code", ->
          code = """
            var fruits = ['apple', 'orange', 'banana'];
            console.log(fruits[1]);
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Conditions', ->
        lesson = JSLessonsList._collection.findOne({id: '1m'})

        it "should return true for correct code", ->
          code = """
            var age = 65;
            if (age >= 18) {
              console.log('You are an adult');
            } else {
              console.log('You are a child');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Switch', ->
        lesson = JSLessonsList._collection.findOne({id: '1v'})

        it "should return true for correct code", ->
          code = """
            var letter = 'b';
            switch (letter) {
              case 'a':
                console.log('letter \"a\"');
                break;
              case 'b':
                console.log('letter \"b\"');
                break;
              case 'c':
                console.log('letter \"c\"');
                break;
              default:
                console.log('Unknown letter');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Logical operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1n'})

        it "should return true for correct code 1", ->
          code = """
            var isPokemon = true;
            var isPikachu = true;
            if (isPokemon && isPikachu) {
              console.log('Pika pika... Pikachu!');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            var isPokemon = false;
            var isPikachu = true;
            if (isPokemon || isPikachu) {
              console.log('Pika pika... Pikachu!');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 3", ->
          code = """
            var isPokemon = true;
            var isPikachu = true;
            if (isPokemon || isPikachu) {
              console.log('Pika pika... Pikachu!');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 4", ->
          code = """
            var isPokemon = true;
            var isPikachu = false;
            if (isPokemon || isPikachu) {
              console.log('Pika pika... Pikachu!');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should NOT return true for bad code", ->
          code = """
            var isPokemon = false;
            var isPikachu = true;
            if (isPokemon && isPikachu) {
              console.log('Pika pika... Pikachu!');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).not.toBe(true)

      describe 'Falsey and truthy', ->
        lesson = JSLessonsList._collection.findOne({id: '1o'})

        it "should return true for correct code 1", ->
          code = """
            //define falsey variable under this line:
            var falseyVar = '';
            if (!falseyVar) {
              console.log('You understand falsey values');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            //define falsey variable under this line:
            var falseyVar = 0;
            if (!falseyVar) {
              console.log('You understand falsey values');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 3", ->
          code = """
            //define falsey variable under this line:
            var falseyVar = null;
            if (!falseyVar) {
              console.log('You understand falsey values');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 4", ->
          code = """
            //define falsey variable under this line:
            var falseyVar;
            if (!falseyVar) {
              console.log('You understand falsey values');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 5", ->
          code = """
            //define falsey variable under this line:
            var falseyVar = NaN;
            if (!falseyVar) {
              console.log('You understand falsey values');
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Loops', ->
        lesson = JSLessonsList._collection.findOne({id: '1p'})

        it "should return true for correct code 1", ->
          code = """
            var fruits = ['orange', 'banana', 'pear'];
            for (var i = 0; i < fruits.length; i++) {
              console.log(fruits[i]);
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            var fruits = ['orange', 'banana', 'pear'];
            for (var i = 0; i <= fruits.length - 1; i++) {
              console.log(fruits[i]);
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Loops - while', ->
        lesson = JSLessonsList._collection.findOne({id: '1t'})

        it "should return true for correct code 1", ->
          code = """
            var fruits = ['orange', 'banana', 'pear'];
            //write while loop under this line:
            var i = 0;
            while (i < fruits.length) {
              console.log(fruits[i]);
              i++;
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            var fruits = ['orange', 'banana', 'pear'];
            //write while loop under this line:
            var i = 0;
            while (i <= fruits.length - 1) {
              console.log(fruits[i]);
              i++;
            }
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Functions', ->
        lesson = JSLessonsList._collection.findOne({id: '1q'})

        it "should return true for correct code 1", ->
          code = """
            function sum(numbers) {
              var sum = 0;
              for (var i = 0; i < numbers.length; i++) {
                sum += numbers[i];
              }
              return sum;
            }
            console.log(sum([2, 3, 6]));
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 2", ->
          code = """
            function sum(numbers) {
              var s = 0;
              for (var i = 0; i < numbers.length; i++) {
                s += numbers[i];
              }
              return s;
            }
            console.log(sum([2, 3, 6]));
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 3", ->
          code = """
            function sum(numbers) {
              var s = 0;
              for (var i = 0; i < numbers.length; i++) {
                s = s + numbers[i];
              }
              return s;
            }
            console.log(sum([2, 3, 6]));
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

        it "should return true for correct code 4", ->
          code = """
            function sum(numbers) {
              var s = 0;
              for (var i = 0; i <= numbers.length - 1; i++) {
                s = numbers[i] + s;
              }
              return s;
            }
            console.log(sum([2, 3, 6]));
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

      describe 'Objects', ->
        lesson = JSLessonsList._collection.findOne({id: '1r'})

        it "should return true for correct code 1", ->
          code = """
            function Person(name, age) {
              this.name = name;
              this.age = age;
              this.sayHello = function() {
                console.log('Hello, my name is ' + this.name);
                console.log('And my age is ' + this.age);
              }
            }
            var peter = new Person('Peter', 31);
            peter.sayHello();
          """
          result = Lesson.checkAssignment(
            lesson: lesson
            code: code
          )
          expect(result).toBe(true)

    , 2000)
