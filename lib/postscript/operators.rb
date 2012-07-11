require "postscript/operators/arithmetic"
require "postscript/operators/boolean"
require "postscript/operators/conditional"
require "postscript/operators/dictionary"
require "postscript/operators/procedure"
require "postscript/operators/stack"

module PostScript

  # Container module for all of the PostScript operators.
  module Operators
    extend ActiveSupport::Concern

    include Stack
    include Arithmetic
    include Dictionary
    include Boolean
    include Conditional
    include Procedure
  end
end
