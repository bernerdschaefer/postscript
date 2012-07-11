module PostScript
  class Interpreter
    class Stack < Array
      def pop(n = nil)
        if n
          if n > length
            raise StackUnderflowError, "#{n} items requested, but stack contains #{length}"
          end
          super
        else
          super()
        end
      end
    end
  end
end
