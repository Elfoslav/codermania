describe "JSExercises.checkExercise", ->
  #arithmetic operators
  Meteor.startup ->
    Meteor.setTimeout(

      describe 'Integer variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1c'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            console.log(1 + 2 < 4);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            console.log( ( 1 + 2 ) < 4);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            console.log(2 + 3 > 5);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 2", ->
          code = """
            console.log( (2 + 3) > 5 );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            console.log(5 + 2 <= 14 / 2);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 2", ->
          code = """
            console.log( (5 + 2) <= (14 / 2) );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code", ->
          code = """
            console.log(9 - 3 >= 2 * 3);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code 2", ->
          code = """
            console.log( (9 - 3) >= (2 * 3) );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ce4']
            code: code
          )
          expect(result).toBe(true)

      describe 'arithmetic operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1i'})

        it "should return true for Exercise 4 correct code", ->
          code = """
            var i = 5;
            i++;
            console.log(i);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            var i = 5;
            ++i;
            console.log(i);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var i = 5;
            i--;
            console.log(i);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 2", ->
          code = """
            var i = 5;
            --i;
            console.log(i);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            console.log( 5 % 3 );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 2", ->
          code = """
            console.log(6 % 4);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ie3']
            code: code
          )
          expect(result).toBe(true)

      describe 'comparision operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1s'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            console.log(1 < 2);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1se1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            console.log( 5 <= 5 );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1se2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            console.log( 5 >= 5 );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1se3']
            code: code
          )
          expect(result).toBe(true)

        it "should not return true for Exercise 4 incorrect code", ->
          code = """
            console.log( '5' == 5 );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1se4']
            code: code
          )
          expect(result).not.toBe(true)

        it "should return true for Exercise 4 correct code", ->
          code = """
            console.log( 5 == '5' );
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1se4']
            code: code
          )
          expect(result).toBe(true)

      describe 'Assignment operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1j'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var number = 1;
            console.log(number);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1je1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var number = 2;
            number += 5;
            console.log(number);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1je2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var number = 3;
            number -= 1;
            console.log(number);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1je3']
            code: code
          )
          expect(result).toBe(true)

        it "should not return true for Exercise 4 incorrect code", ->
          code = """
            var number = 4;
            number *= 2;
            console.log(number);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1je4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 5 correct code", ->
          code = """
            var number = 5;
            number /= 2;
            console.log(number);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1je5']
            code: code
          )
          expect(result).toBe(true)

      describe 'String operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1k'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var someText = \"Lorem ipsum\";
            someText += \" dolor sit amet\";
            console.log(someText);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ke1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var fruit1 = 'apple';
            var fruit2 = 'banana';
            var appleAndBanana = fruit1 + ' and ' + fruit2;
            console.log(appleAndBanana);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ke2']
            code: code
          )
          expect(result).toBe(true)

      describe 'Integer variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1f'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var number1 = 45;
            var number2 = 100;
            var result = number1 + number2;
            console.log(result);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1fe1']
            code: code
          )
          expect(result).toBe(true)

      describe 'Float variables', ->
        lesson = JSLessonsList._collection.findOne({id: '1g'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var number1 = 0.55;
            var number2 = 0.199;
            var result = number1 + number2;
            console.log(result);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ge1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var number1 = 0.55;
            var number2 = 0.199;
            var result = number1 + number2;
            console.log(result.toFixed(2));
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ge2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var number1 = 0.55;
            var number2 = 0.199;
            var result = number1 + number2;
            var roundedResult = result.toFixed(2);
            console.log(roundedResult + 3);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ge3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code", ->
          code = """
            var number1 = 0.55;
            var number2 = 0.199;
            var result = number1 + number2;
            var roundedResult = result.toFixed(2);
            console.log(parseFloat(roundedResult) + 3);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ge4']
            code: code
          )
          expect(result).toBe(true)

      describe 'Arrays', ->
        lesson = JSLessonsList._collection.findOne({id: '1l'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var numbers = [];
            numbers.push(1);
            numbers.push(2);
            console.log(numbers[0]);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1le1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var bands = [ 'Metallica', 'Iron Maiden' ];
            bands.push('AC/DC');
            console.log(bands[0]);
            console.log(bands[2]);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1le2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var numbers = [ 5, 8, 3.3 ];
            console.log(numbers[0] + numbers[1] + numbers[2]);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1le3']
            code: code
          )
          expect(result).toBe(true)

      describe 'Conditions', ->
        lesson = JSLessonsList._collection.findOne({id: '1m'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var fruit = 'banana';
            if ( fruit == 'banana' ) {
              console.log('variable fruit has value banana');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            var fruit = 'banana';
            if (fruit === 'banana') {
              console.log('variable fruit has value banana');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var isHappy = true;
            if (isHappy == true) {
              console.log('He is happy');
            } else {
              console.log('He is not happy');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 2", ->
          code = """
            var isHappy = true;
            if (isHappy) {
              console.log('He is happy');
            } else {
              console.log('He is not happy');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var name = 'Josh';
            if (name == 'Peter') {
              console.log('Hello Peter');
            } else if (name == 'John') {
              console.log('Hello John');
            } else {
              console.log('Hello stranger');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me3']
            code: code
          )
          expect(result).toBe(true)

        #indentation with tabs
        it "should return true for Exercise 3 correct code 2", ->
          code = """
            var name = 'Josh';
            if (name === 'Peter') {
            	console.log('Hello Peter');
            } else if (name === 'John') {
            	console.log('Hello John');
            } else {
            	console.log('Hello stranger');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1me3']
            code: code
          )
          expect(result).toBe(true)

      describe 'Logical operators', ->
        lesson = JSLessonsList._collection.findOne({id: '1n'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var isHappy = true;
            if (!isHappy) {
              console.log('He is unhappy');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ne1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var isHappy = true;
            var isHuman = true;
            if (isHappy && isHuman) {
              console.log('Hello happy human');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ne2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var isHappy = true;
            var isHuman = false;
            if (isHappy || isHuman) {
              console.log('You are happy or you are a human');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1ne3']
            code: code
          )
          expect(result).toBe(true)

      describe 'Truthy and falsey', ->
        lesson = JSLessonsList._collection.findOne({id: '1o'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var truthy = 'banana';
            if (truthy == true) {
              console.log('hello truthy');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            var truthy = true;
            if (truthy) {
              console.log('hello truthy');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var falsey = false;
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 2", ->
          code = """
            var falsey = '';
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 3", ->
          code = """
            var falsey = 0;
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 4", ->
          code = """
            var falsey = null;
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 5", ->
          code = """
            var falsey = undefined;
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 6", ->
          code = """
            var falsey;
            if (falsey) {
              console.log('hello falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 1", ->
          code = """
            var falsey;
            if (!falsey) {
              console.log('hello negated falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 2", ->
          code = """
            var falsey = undefined;
            if (!falsey) {
              console.log('hello negated falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 3", ->
          code = """
            var falsey = 0;
            if (!falsey) {
              console.log('hello negated falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe3']
            code: code
          )
          expect(result).toBe(true)

        it "should not return true for Exercise 3 incorrect code", ->
          code = """
            var falsey = 1;
            if (!falsey) {
              console.log('hello negated falsey');
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1oe3']
            code: code
          )
          expect(result).not.toBe(true)

      describe 'Loops - for', ->
        lesson = JSLessonsList._collection.findOne({id: '1p'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            for (var i = 0; i < 5; i++) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            for (var i = 0; i <= 4; i++) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe1']
            code: code
          )
          expect(result).toBe(true)

        it "should not return true for Exercise 1 incorrect code", ->
          code = """
            for (var i = 0; i < 6; i++) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe1']
            code: code
          )
          expect(result).not.toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            for (var i = 5; i > 0; i--) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code 2", ->
          code = """
            for (var i = 5; i >= 1; i--) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            for (var i = 0; i < 21; i = i + 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 2", ->
          code = """
            for (var i = 0; i < 21; i += 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 3", ->
          code = """
            for (var i = 0; i <= 20; i = i + 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code 4", ->
          code = """
            for (var i = 0; i <= 20; i += 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code", ->
          code = """
            for (var i = 1; i <= 20; i += 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code 2", ->
          code = """
            for (var i = 1; i < 20; i += 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code 3", ->
          code = """
            for (var i = 1; i < 20; i = i + 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code 4", ->
          code = """
            for (var i = 1; i <= 19; i = i + 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code 5", ->
          code = """
            for (var i = 1; i <= 19; i += 2) {
              console.log(i);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe4']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 5 correct code", ->
          code = """
            var bands = ['Metallica', 'AC/DC', 'Iron Maiden'];
            for (var i = 0; i < bands.length; i++) {
              console.log(bands[i]);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe5']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 5 correct code 2", ->
          code = """
            var bands = [ 'Metallica', 'AC/DC', 'Iron Maiden' ];
            for (var i = 0; i <= bands.length - 1; i++) {
              console.log(bands[i]);
            }
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1pe5']
            code: code
          )
          expect(result).toBe(true)

      describe 'Functions', ->
        lesson = JSLessonsList._collection.findOne({id: '1q'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            function printNameAndAge(name, age) {
              console.log('Hi ' + name);
              console.log('You are ' + age + ' years old');
            }
            printNameAndAge('Tom', 28);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1qe1']
            code: code
          )
          expect(result).toBe(true)

        it "should NOT return true for Exercise 1 incorrect code", ->
          code = """
            function printNameAndAge(name, age) {
              console.log('Hi ' + name);
              console.log('You are ' + age + ' years old');
            }
            printNameAndAge('Tom', 29);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1qe1']
            code: code
          )
          expect(result).not.toBe(true)

        it "should NOT return true for Exercise 1 incorrect code 2", ->
          code = """
            function printNameAndAge(name, age) {
              console.log('Hi ' + name);
              console.log('You are ' + age + ' years old');
            }
            printNameAndAge('Tomas', 28);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1qe1']
            code: code
          )
          expect(result).not.toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            function multiply(a, b) {
              return a * b;
            }
            console.log(multiply(5, 2));
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1qe2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            function printArray(arr) {
              for (var i = 0; i < arr.length; i++) {
                console.log(arr[i]);
              }
            }
            printArray([5, 10, 15]);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1qe3']
            code: code
          )
          expect(result).toBe(true)

      describe 'Objects', ->
        lesson = JSLessonsList._collection.findOne({id: '1r'})

        it "should return true for Exercise 1 correct code", ->
          code = """
            var car = {
              name: 'BMW',
              speed: 250,
              accelerate: function() {
                this.speed++;
              },
              toString: function() {
                return 'Car ' + this.name + ' has speed ' + this.speed;
              }
            };
            console.log(car.toString());
            car.accelerate();
            console.log(car.toString());
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1re1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 1 correct code 2", ->
          code = """
            var car = {
              name: 'BMW',
              speed: 250,
              accelerate: function() {
                this.speed += 1;
              },
              toString: function() {
                return 'Car ' + this.name + ' has speed ' + this.speed;
              }
            };
            console.log(car.toString());
            car.accelerate();
            console.log(car.toString());
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1re1']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 2 correct code", ->
          code = """
            var person = {
              name: 'Tomas'
            };
            console.log(person.name);
            person.name = 'Josh';
            console.log(person.name);
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1re2']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 3 correct code", ->
          code = """
            var dog = {
              name: 'Benny',
              bark: function() {
                console.log('wof wof');
              }
            };
            console.log(dog.name);
            dog.bark();
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1re3']
            code: code
          )
          expect(result).toBe(true)

        it "should return true for Exercise 4 correct code", ->
          code = """
            var Dog = function(name) {
              this.name = name;
              this.bark = function() {
                console.log('wof wof');
              };
            }
            var dog = new Dog('Ben');
            console.log(dog.name);
            dog.bark();
          """
          result = JSExercise.checkExercise(
            lesson: lesson
            exercise: lesson.exercises['1re4']
            code: code
          )
          expect(result).toBe(true)

    , 2000)
