require "postscript/operators/arithmetic"
require "postscript/operators/boolean"
require "postscript/operators/conditional"
require "postscript/operators/stack"

module PostScript

  # Container module for all of the PostScript operators.
  module Operators
    include Stack

    include Arithmetic
    include Boolean
    include Conditional
  end
end
