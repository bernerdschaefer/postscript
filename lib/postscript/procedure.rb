module PostScript
  class Procedure < Array
    def call(interpreter)
      return if empty?

      interpreter.execution_stack.concat self
    end
  end
end
