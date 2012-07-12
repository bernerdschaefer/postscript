module PostScript
  module Operators

    # A module containing all defined control operators available to the
    # PostScript runtime.
    module Control
      extend ActiveSupport::Concern

      included do
        # Executes the procedure if the test condition is true.
        operator "if", [Object, PostScript::Procedure] do |bool, proc|
          execution_stack.push proc if bool
        end

        # Executes the procedure if the test condition is true.
        operator "ifelse", [Object, PostScript::Procedure, PostScript::Procedure] do |bool, proc1, proc2|
          if bool
            execution_stack.push proc1
          else
            execution_stack.push proc2
          end
        end

        # Execute +proc+ with values from +initial+ by steps of +increment+ to +limit+.
        operator "for", [Numeric, Numeric, Numeric, PostScript::Procedure] do |initial, increment, limit, proc|
          return if initial.zero? && increment.zero?

          current = initial
          comparator = increment > 0 ? :<= : :>=

          for_proc = ->(interpreter) do
            if current.send(comparator, limit)
              interpreter.push current
              current += increment
              interpreter.execution_stack.push for_proc, proc
            end
          end

          execution_stack.push for_proc
        end

        operator "quit" do
          # Not quite sure if this is the correct behavior, but it seems to be
          # accurate.
          execution_stack.clear
        end
      end
    end
  end
end
