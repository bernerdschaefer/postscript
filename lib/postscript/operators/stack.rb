module PostScript
  module Operators
    module Stack

      # Adds a copy of the last +n+ elements on the stack.
      def copy
        n = pop

        push *stack.last(n)
      end

      # Adds a duplicate copy of the top element to the end of the stack.
      def dup
        push stack.last
      end

      # Swaps the last two elements on the stack.
      def exch
        y = pop
        x = pop

        push y
        push x
      end

      # Adds a copy of the +n+th element on the stack.
      def index
        push stack[pop]
      end

      # Removes and returns the last element from the stack.
      #
      # @return the last element from the stack
      def pop
        stack.pop
      end

      # Moves the last +n+ elements +j+ positions on the stack, rolling over at
      # stack boundaries.
      def roll
        j = pop
        n = pop

        stack.push *stack.pop(n).rotate(-j)
      end

    end
  end
end
