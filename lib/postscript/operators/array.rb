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

        operator "array", [Numeric] do |size|
          push ::Array.new(size)
        end

      end
    end
  end
end
