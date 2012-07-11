module PostScript
  class Procedure < Array
    def call(interpreter)
      interpreter.execution_stack.push self

      *operators, last = self
      operators.each do |operand|
        interpreter.trigger operand
      end

      interpreter.execution_stack.pop
      interpreter.trigger last
    end
  end
end
