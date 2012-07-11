module PostScript
  class Procedure < Array
    def call(interpreter)
      execution_stack = interpreter.execution_stack

      execution_stack.push self

      *operators, last = self
      operators.each do |operand|
        interpreter.trigger operand
      end

      execution_stack.pop
      execution_stack.push last
    end
  end
end
