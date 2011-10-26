module PostScript
  module Operators
    module Boolean

      # Tests whether the last two elements are equal.
      def eq
        push pop == pop
      end

      # Tests whether the last two elements are not equal.
      def ne
        push pop != pop
      end

      # Tests whether num1 is greater than num2
      def gt
        x, y = stack.pop(2)
        push x > y
      end

      # Tests whether num1 is greater than or equal to num2
      def ge
        x, y = stack.pop(2)
        push x >= y
      end

      # Tests whether num1 is less than num2
      def lt
        x, y = stack.pop(2)
        push x < y
      end

      # Tests whether num1 is less than or equal to num2
      def le
        x, y = stack.pop(2)
        push x <= y
      end

      # Performs a logical or bitwise and on the last two elements.
      def and
        x, y = stack.pop(2)
        push x & y
      end

      # Performs a logical or bitwise or on the last two elements.
      def or
        x, y = stack.pop(2)
        push x | y
      end

      # Performs a logical or bitwise exclusive or on the last two elements.
      def xor
        x, y = stack.pop(2)
        push x ^ y
      end

      # Performs a logical or bitwise not on the last element.
      def not
        x = pop

        push x.respond_to?(:~) ? ~x : !x
      end

    end
  end
end
