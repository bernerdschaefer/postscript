module PostScript
  module Operators
    module Arithmetic

      # Replaces the last two elements with their sum.
      def add
        y = pop
        x = pop

        push x + y
      end

      # Replaces the last two elements with their difference.
      def sub
        y = pop
        x = pop

        push x - y
      end

      # Replaces the last two elements with their product.
      def mul
        y = pop
        x = pop

        push x * y
      end

      # Replaces the last two elements with their quotient.
      def div
        y = pop
        x = pop

        push x / y
      end
      alias idiv div

      # Replaces the last two elements with their remainder.
      def mod
        y = pop
        x = pop

        push x % y
      end

      # Replaces the last element with its negated value.
      def neg
        push -pop
      end

      # Replaces the last element with its absolute value.
      def abs
        push pop.abs
      end

      # Replaces the last element with its ceil value.
      def ceiling
        push pop.ceil
      end

      # Replaces the last element with its floor value.
      def floor
        push pop.floor
      end

      # Replaces the last element with its rounded value.
      def round
        push pop.round
      end

      # Replaces the last element with its truncated value.
      def truncate
        push pop.truncate
      end

      # Replaces the last element with its square root.
      def sqrt
        push Math.sqrt(pop)
      end

      # Replaces the last element with its sine.
      def sin
        push Math.sin(pop)
      end

      # Replaces the last element with its cosine.
      def cos
        push Math.cos(pop)
      end

      # Replaces the last two elements with their arc tangent.
      def atan
        y = pop
        x = pop

        push Math.atan2(x, y)
      end

      # Replaces the last two elements with their exponent.
      def exp
        y = pop
        x = pop

        push x ** y
      end

      # Replaces the last element with its natural (base e) logarithm.
      def ln
        push Math.log(pop)
      end

      # Replaces the last element with its common (base 10) logarithm.
      def log
        push Math.log10(pop)
      end

      # Converts the last element into an integer.
      def cvi
        push pop.to_i
      end

      # Converts the last element into an real (float).
      def cvr
        push pop.to_f
      end

    end
  end
end
