require "postscript/interpreter/stack"

module PostScript
  class Interpreter
    class ExecutionStack < Stack

      def initialize
        @lexer = Lexer.new
      end

      def next_token
        current = last

        if current.respond_to? :getc
          @lexer.next_token(current)
        else
          pop
        end
      end

    end
  end
end
