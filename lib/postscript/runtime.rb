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

    include Support::StateMachine
    include Operators

    attr_reader :lexer

    def initialize
      @lexer = Lexer.new
    end

    # Evaluates the provided PostScript function and returns the stack.
    #
    # @example
    #
    #   runtime.eval "{ 40 60 add 2 div }" # => [50]
    #
    # @param [String] function the function to evaluate.
    # @return [Array] the stack after evaluating the provided function.
    def eval(function)
      source = Source.new(function)

      while (token = lexer.next_token(source)) != :eof
        call token
      end

      stack
    end

    push = ->(context, event) { context[:runtime].push(event) }
    call = ->(context, event) do
      context[:runtime].send(event)
    end
    nest = ->(context, event) { context[:nesting] = (context[:nesting] || 0) + 1 }
    unnest = ->(context, event) { context[:nesting] -= 1 }
    transition = ->(to) {
      ->(context, _) { context.transition to }
    }

    state :default do
      on /{/, call, nest, transition[:scan_only]
      on Procedure do |context, procedure|
        procedure.call(context[:runtime])
      end
      on Name, call
      on Object, push
    end

    state :scan_only do
      on "{", nest, call
      on "}", unnest, call do |context|
        context.transition :default if context[:nesting] == 0
      end

      on Object, push
    end

    # Evaluates the result of a parsed PostScript procedure.
    #
    # @api private
    def call(token)
      @state ||= Context.new :default, runtime: self

      machine.trigger @state, token

#       if @scan_only
#         return push(token) unless token.respond_to?(:immediate) && token.immediate
#       end

#       case token
#       when Procedure
#         token.call self
#       when Name
#         if token.executable
#           send token.to_sym
#         else
#           push token
#         end
#       else
#         push token
#       end
    rescue Exception => e

      # puts token
      # puts stack.inspect

      raise
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
