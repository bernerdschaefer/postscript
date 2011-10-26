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
      ast = Parser.parse(function)

      eval_ast ast
    end

    # Evaluates the result of a parsed PostScript procedure.
    #
    # @api private
    def eval_ast(ast)
      ast.each do |node|
        if node.is_a? Symbol
          send node
        else
          push node
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
