module PostScript
  module Operators

    # A module containing all defined stack methods available to the PostScript
    # runtime.
    module Stack
      extend ActiveSupport::Concern

      included do
        # Discards the topmost element
        operator "pop", [Object] do |op|
        end

        # Swaps the last two elements on the stack.
        operator "exch", [Object, Object] do |op1, op2|
          push op2, op1
        end

        # Duplicate the top element
        operator "dup" do
          push stack.last
        end

        # Adds a copy of the last +n+ elements on the stack.
        operator "copy", [Numeric] do |n|
          push *stack.last(n)
        end

        # Adds a copy of the +n+th element on the stack.
        operator "index", [Numeric] do |n|
          push stack[-(n + 1)]
        end

        # Moves the last +n+ elements +j+ positions on the stack, rolling over at
        # stack boundaries.
        operator "roll", [Numeric, Numeric] do |n, j|
          push *stack.pop(n).rotate(-j)
        end

      end
    end
  end
end
