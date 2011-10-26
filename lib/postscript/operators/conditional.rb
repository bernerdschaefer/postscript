module PostScript
  module Operators
    module Conditional

      # Executes the procedure if the test condition is true.
      def if
        procedure = pop

        eval_ast procedure if pop

        stack
      end

      # Executes the procedure if the test condition is true.
      def ifelse
        procedure2 = pop
        procedure1 = pop

        if pop
          eval_ast procedure1
        else
          eval_ast procedure2
        end

        stack
      end

    end
  end
end
