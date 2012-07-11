require "postscript/operators/arithmetic"
require "postscript/operators/array"
require "postscript/operators/boolean"
require "postscript/operators/control"
require "postscript/operators/dictionary"
require "postscript/operators/procedure"
require "postscript/operators/stack"

module PostScript

  # Container module for all of the PostScript operators.
  module Operators
    extend ActiveSupport::Concern

    include Arithmetic
    include Array
    include Boolean
    include Control
    include Dictionary
    include Procedure
    include Stack

    included do

      operator "readonly" do
        warn "ignoring #readonly"
      end

    end
  end
end
