module PostScript
  module Operators

    # A module containing all defined conditional methods available to the
    # PostScript runtime.
    module Conditional
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

      end
    end
  end
end
