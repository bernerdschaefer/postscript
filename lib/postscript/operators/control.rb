module PostScript
  module Operators

    # A module containing all defined control operators available to the
    # PostScript runtime.
    module Control
      extend ActiveSupport::Concern

      included do
        # Executes the procedure if the test condition is true.
        operator "if", [Object, PostScript::Procedure] do |bool, proc|
          trigger proc if bool
        end

        # Executes the procedure if the test condition is true.
        operator "ifelse", [Object, PostScript::Procedure, PostScript::Procedure] do |bool, proc1, proc2|
          if bool
            trigger proc1
          else
            trigger proc2
          end
        end

        # Execute +proc+ with values from +initial+ by steps of +increment+ to +limit+.
        operator "for", [Numeric, Numeric, Numeric, PostScript::Procedure] do |initial, increment, limit, proc|
          (initial..limit).step(increment) do |value|
            push value
            trigger proc
          end
        end
      end
    end
  end
end
