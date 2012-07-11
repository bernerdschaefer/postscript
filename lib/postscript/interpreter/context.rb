module PostScript
  class Interpreter
    class Context < Support::StateMachine::Context
      def initialize(interpreter)
        @interpreter = interpreter

        super :default
      end

      def stack
        @interpreter.stack
      end

      def dictionary_stack
        @interpreter.dictionary_stack
      end

      def execution_stack
        @interpreter.execution_stack
      end
    end
  end
end
