module PostScript
  class Operator
    # Public: Define an operator with a name, signature, and definition.
    #
    # name      - A String naming this operator.
    # signature - An Array of matchable items, or nil. If the signature is an array,
    #             then each item will be compared with the arguments using
    #             `===`. If nil, then no arguments will be checked.
    # handler   - A required block with the code an operator will execute. It
    #             will be executed in the context of the interpreter. If a signature is
    #             defined, the block will be called with the same number of arguments
    #             as the signature.
    #
    # Examples:
    #
    #   # Define an operator two numeric arguments
    #   PostScript::Operator.new "add", [Numeric, Numeric] do |a, b|
    #     push a + b
    #   end
    #
    #   # Define an operator with no arguments
    #   PostScript::Operator.new "rand" do
    #     push SecureRandom.random_number(2 ** 31 - 1)
    #   end
    def initialize(name, signature = nil, &handler)
      @name = name
      @signature = signature
      @handler = handler
    end

    # Internal: Execute an operator in an interpreter
    #
    # Returns nothing.
    # Raises ArgumentError when the argument types are mismatched
    def call(interpreter)
      if @signature
        arguments = interpreter.pop @signature.length

        arguments.zip(@signature) do |value, matcher|
          unless matcher === value
            raise ArgumentError,
              "Operator #{@name} expected arguments to match #{@signature.inspect} but got: #{arguments.inspect}"
          end
        end

        interpreter.instance_exec(*arguments, &@handler)
      else
        interpreter.instance_eval &@handler
      end
    end

    def inspect
      "-- #{@name} --"
    end

  end
end
