module PostScript

  # The Runtime is responsible for evaluating procedures (as arrays output from
  # Parser, or as strings to be parsed) and maintaining the stack.
  #
  # It responds to all of the supported operators.
  #
  # @example Manually manipulating the runtime
  #
  #   ps = PostScript::Runtime.new
  #   ps.stack  # => []
  #   ps.push 2 # => [2]
  #   ps.push 2 # => [2, 2]
  #   ps.mul    # => [4]
  #   ps.push 2 # => [4, 2]
  #   ps.div    # => [2]
  #   ps.stack  # => [2]
  #
  # @example Evaluating PostScript
  #
  #   ps = PostScript::Runtime.new
  #   ps.stack  # => []
  #   ps.eval "{ 2 2 mul 2 div }"
  #   ps.stack  # => [2]
  #
  # @example Setting the state for a PostScript procedure
  #
  #   ps = PostScript::Runtime.new
  #
  #   # Set up the initial state
  #   ps.push -4.0, 2.0
  #
  #   # Execute the "Rhomboid" spot function as defined in the PDF Spec.
  #   ps.eval "{ abs exch abs 0.9 mul add 2 div }" # => [2.8]
  #
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
