module PostScript
  module Operators
    module Procedure
      extend ActiveSupport::Concern

      included do
        operator "{" do
          push Mark
          self[:procedure_nesting] = (self[:procedure_nesting] || 0) + 1
          transition :scan_procedure
        end

        operator "}" do
          operators = []

          until (value = pop) == Mark
            operators.unshift value
          end

          push PostScript::Procedure.new(operators)

          self[:procedure_nesting] -= 1
          transition :default if self[:procedure_nesting] == 0
        end
      end

    end
  end
end
