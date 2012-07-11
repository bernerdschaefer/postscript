module PostScript
  class Interpreter
    GlobalDictionary = Class.new(Dictionary) do
      def inspect
        "-globaldict-"
      end
    end.new
  end
end
