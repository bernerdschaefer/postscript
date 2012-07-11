module PostScript
  class Interpreter
    class UserDictionary < Dictionary
      def inspect
        "-userdict-"
      end
    end
  end
end
