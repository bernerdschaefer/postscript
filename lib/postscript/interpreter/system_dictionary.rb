module PostScript
  class Interpreter
    SystemDictionary = Class.new(Dictionary) do
      include Operators

      def inspect
        "-systemdict-"
      end
    end.new.freeze
  end
end
