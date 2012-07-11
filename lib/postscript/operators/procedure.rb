module PostScript
  module Operators
    module Procedure
      extend ActiveSupport::Concern

      included do
        operator "{" do
          push PostScript::Procedure.new
          self[:procedure_nesting] = (self[:procedure_nesting] || 0) + 1
          transition :scan_procedure
        end

        operator "}" do
          operators = []

          until (value = pop).is_a?(PostScript::Procedure)
            operators.unshift value
          end

          value.replace operators
          push value

          self[:procedure_nesting] -= 1
          transition :default if self[:procedure_nesting] == 0
        end
      end

    end
  end
end
