module PostScript
  class Runtime

    include Operators

    # Evaluates the provided PostScript function and returns the stack.
    #
    # @example
    #
    #   runtime.eval "{ 40 60 add 2 div }" # => [50]
    #
    # @param [String] function the function to evaluate.
    # @return [Array] the stack after evaluating the provided function.
    def eval(function)
      eval_procedure Parser.parse(function)
      stack
    end

    # Evaluates the result of a parsed PostScript procedure.
    #
    # @api private
    def eval_procedure(procedure)
      procedure.each do |operator|
        if operator.is_a? Symbol
          send operator
        else
          push operator
        end
      end
    end

    # Pushes the provided operator onto the stack. This is most useful for
    # setting up the initial state before evaluating a PostScript function.
    #
    # @example
    #
    #   runtime.push 2
    #   runtime.eval "{ dup mult }" # => [4]
    #
    # @param elements elements to add to the stack
    def push(*elements)
      stack.push *elements
    end

    # @return [Array] the current stack
    def stack
      @stack ||= []
    end

  end
end
