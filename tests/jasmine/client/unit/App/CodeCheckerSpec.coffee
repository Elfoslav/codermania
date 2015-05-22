describe "CodeCheckerSpec", ->

  describe 'CodeChecker.hasIndentation', ->
    it "should return true for code 1", ->
      code = "  console.log(1 + 2 < 4);"
      result = CodeChecker.hasIndentation(code)
      expect(result).toBe(true)

    it "should return true for code 2", ->
      code = "    console.log(1 + 2 < 4);"
      result = CodeChecker.hasIndentation(code, 4)
      expect(result).toBe(true)

    it "should return true for code 3", ->
      code = "      console.log(1 + 2 < 4);"
      result = CodeChecker.hasIndentation(code, 6)
      expect(result).toBe(true)

    it "should return true for code 4", ->
      #code with one tab
      code = "	console.log(1 + 2 < 4);"
      result = CodeChecker.hasIndentation(code, 2)
      expect(result).toBe(true)

    it "should return false for code 5", ->
      #code with one tab
      code = "	console.log(1 + 2 < 4);"
      result = CodeChecker.hasIndentation(code, 3)
      expect(result).toBe(false)
