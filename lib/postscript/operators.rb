require "postscript/operators/arithmetic"
require "postscript/operators/boolean"
require "postscript/operators/stack"

module PostScript
  module Operators
    include Stack

    include Arithmetic
    include Boolean
  end
end
