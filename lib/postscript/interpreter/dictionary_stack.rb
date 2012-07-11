require "postscript/interpreter/stack"

module PostScript
  class Interpreter
    class DictionaryStack < Stack
      def []=(key, value)
        last[key] = value
      end

      def [](key)
        dictionary = reverse.find { |dict| dict.has_key? key } or
          raise NameError.new("undefined name #{key}")
        dictionary[key]
      end
    end
  end
end
