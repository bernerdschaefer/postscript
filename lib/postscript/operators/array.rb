module PostScript
  module Operators
    module Array
      extend ActiveSupport::Concern

      included do

        operator "[" do
          push Mark
        end

        operator "]" do
          operators = []

          until (value = pop) == Mark
            operators.unshift value
          end

          push operators
        end

      end
    end
  end
end
