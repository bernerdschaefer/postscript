module PostScript
  module Operators

    # A module containing all defined relational, boolean, and bitwise methods
    # available to the PostScript runtime.
    module Boolean
      extend ActiveSupport::Concern

      included do
        # Tests whether the last two elements are equal.
        operator "eq", [Object, Object] do |a, b|
          push a == b
        end

        # Tests whether the last two elements are not equal.
        operator "ne", [Object, Object] do |a, b|
          push a != b
        end

        # Tests whether num1 is greater than num2
        operator "gt", [Object, Object] do |a, b|
          push a > b
        end

        # Tests whether num1 is greater than or equal to num2
        operator "ge", [Object, Object] do |a, b|
          push a >= b
        end

        # Tests whether num1 is less than num2
        operator "lt", [Object, Object] do |a, b|
          push a < b
        end

        # Tests whether num1 is less than or equal to num2
        operator "le", [Object, Object] do |a, b|
          push a <= b
        end

        # Performs a logical or bitwise and on the last two elements.
        operator "and", [Object, Object] do |a, b|
          push a & b
        end

        # Performs a logical or bitwise not on the last element.
        operator "not", [Object] do |a|
          push a.respond_to?(:~) ? ~a : !a
        end

        # Performs a logical or bitwise or on the last two elements.
        operator "or", [Object, Object] do |a, b|
          push a | b
        end

        # Performs a logical or bitwise exclusive or on the last two elements.
        operator "xor", [Object, Object] do |a, b|
          push a ^ b
        end

        # Shifts +int1+ +shift+ bits.
        operator "bitshift", [Integer, Integer] do |int, shift|
          push int << shift
        end

      end
    end
  end
end
