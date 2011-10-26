module PostScript
  module Operators

    # A module containing all defined conditional methods available to the
    # PostScript runtime.
    module Conditional

      # Executes the procedure if the test condition is true.
      def if
        procedure = pop

        eval_procedure procedure if pop

        stack
      end

      # Executes the procedure if the test condition is true.
      def ifelse
        procedure1, procedure2 = stack.pop(2)

        if pop
          eval_procedure procedure1
        else
          eval_procedure procedure2
        end

        stack
      end

    end
  end
end
