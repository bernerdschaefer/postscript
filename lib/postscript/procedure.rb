module PostScript
  class Procedure < Array
    def call(interpreter)
      return if empty?

      proc = dup

      iterator = ->(interpreter) do
        if op = proc.pop
          interpreter.execution_stack.push iterator
          interpreter.trigger op
        end
      end

      interpreter.execution_stack.push iterator
    end
  end
end
