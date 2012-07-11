module PostScript
  class Interpreter
    class Stack < Array
      def pop(n = 1)
        if n > length
          raise StackUnderflowError, "#{n} items requested, but stack contains #{length}"
        end

        super
      end
    end
  end
end
