dictionary_stack = [
  :systemdict,
  :globaldict,
  :userdict
]

operand_stack = []
execution_stack = []

module PostScript
  # PostScript string object.
  class String; end

  # PostScript "atom" object.
  class Name < String; end

  class Dictionary; end

  class Operator; end

  class File; end

  class Mark; end
end

class Name < String; end

class Interpreter

  def call(name)
    value = self[name]

    if value.respond_to? :call
      push *value.call(self, *pop(value.arity - 1))
    else
      push value
    end
  end

  def run
    while token = @tokenizer.next
      if token.is_a? Name
        value = self[token]

        if value.respond_to? :call
          push *value.call(self, *pop(value.arity - 1))
        else
          push value
        end
      else
        push token
      end
    end
  end

  def pop(*args)
    operand_stack.pop *args
  end

  def push(*values)
    operand_stack.push *values
  end

  private

  def current_file
    execution_stack.last
  end

  def current_dictionary
    dictionary_stack.last
  end

  def []=(name, value)
    current_dictionary[name] = value
  end

  def [](name)
    dictionary_stack.reverse_each do |dictionary|
      return dictionary[name] if dictionary.has_key? name
    end

    nil
  end

  def dictionary_stack
    @dictionary_stack ||= []
  end

  def execution_stack
    @execution_stack ||= []
  end

  def operand_stack
    @operand_stack ||= []
  end
end

# class SystemDictionary < Dictionary
# end
# system = SystemDictionary.new
system = {}
system[Name.new("true")] = ->(interpreter) { true }
system[Name.new("false")] = ->(interpreter) { false }
system[Name.new("eq")] = ->(interpreter, cond1, cond2) { cond1 == cond2 }

interpreter = Interpreter.new
interpreter.send(:dictionary_stack) << system

p interpreter.call "true"
p interpreter.call "false"
p interpreter.call "eq"
p interpreter.call "false"
p interpreter.call "eq"
