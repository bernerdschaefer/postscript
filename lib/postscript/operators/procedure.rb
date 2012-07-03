module PostScript
  class Procedure < Array
    def call(runtime)
      each do |operand|
        runtime.call operand
      end
    end
  end

  module Operators
    module Procedure
      define_method "{" do
        push PostScript::Procedure.new
      end

      define_method "}" do
        operands = []

        until (value = pop).is_a?(PostScript::Procedure)
          operands.unshift value
        end

        value.replace operands
        push value
      end
    end
  end
end
