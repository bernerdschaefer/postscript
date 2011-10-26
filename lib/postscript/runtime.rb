module PostScript
  class Runtime

    # Evaluates the provided PostScript function and returns the stack.
    #
    # @example
    #
    #   runtime.eval "{ 40 60 add 2 div }" # => [50]
    #
    # @param [String] function the function to evaluate.
    # @return [Array] the stack after evaluating the provided function.
    def eval(function) ; end

    # Pushes the provided operator onto the stack. This is most useful for
    # setting up the initial state before evaluating a PostScript function.
    #
    # @example
    #
    #   runtime.push 2
    #   runtime.eval "{ dup mult }" # => [4]
    #
    # @param operator an operator to add to the stack.
    def push(operator) ; end

    # @return [Array] the current stack
    def stack ; end

  end
end
