module PostScript
  module Operators
    module Procedure
      extend ActiveSupport::Concern

      included do
        operator "{" do
          push PostScript::Procedure.new
        end

        operator "}" do
          operators = []

          until (value = pop).is_a?(PostScript::Procedure)
            operators.unshift value
          end

          value.replace operators
          push value
        end
      end

    end
  end
end
