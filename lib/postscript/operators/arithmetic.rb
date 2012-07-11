module PostScript
  module Operators

    # A module containing all defined arithmetic methods available to the
    # PostScript runtime.
    module Arithmetic
      extend ActiveSupport::Concern

      included do
        operator "add", [Numeric, Numeric] do |x, y|
          push x + y
        end

        operator "sub", [Numeric, Numeric] do |x, y|
          push x - y
        end

        operator "mul", [Numeric, Numeric] do |x, y|
          push x * y
        end

        operator "div", [Numeric, Numeric] do |x, y|
          push x.fdiv(y)
        end

        operator "idiv", [Integer, Integer] do |x, y|
          push x / y
        end

        operator "mod", [Integer, Integer] do |x, y|
          push x % y
        end

        operator "neg", [Numeric] do |x|
          push -x
        end

        operator "abs", [Numeric] do |x|
          push x.abs
        end

        operator "ceiling", [Numeric] do |x|
          push x.ceil
        end

        operator "floor", [Numeric] do |x|
          push x.floor
        end

        operator "round", [Numeric] do |x|
          push x.round
        end

        operator "truncate", [Numeric] do |x|
          push x.truncate
        end

        operator "sqrt", [Numeric] do |x|
          push Math.sqrt(x)
        end

        operator "sin", [Numeric] do |x|
          push Math.sin(x)
        end

        operator "cos", [Numeric] do |x|
          push Math.cos(x)
        end

        operator "atan", [Numeric, Numeric] do |x, y|
          push Math.atan2(x, y)
        end

        operator "exp", [Numeric, Numeric] do |x, y|
          push x ** y
        end

        operator "ln", [Numeric] do |x|
          push Math.log(x)
        end

        operator "log", [Numeric] do |x|
          push Math.log10(x)
        end

        operator "rand" do
          push SecureRandom.random_number(2 ** 31 - 1)
        end

        operator "srand", [Integer] do |int|
          Kernel.srand int
        end

        operator "rrand" do
          push Kernel.srand
        end
      end

    end
  end
end
