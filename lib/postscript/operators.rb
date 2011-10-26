require "postscript/operators/arithmetic"
require "postscript/operators/stack"

module PostScript
  module Operators
    include Stack
    include Arithmetic
  end
end
