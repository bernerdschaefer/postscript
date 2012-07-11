require "postscript/support/state_machine"

require "postscript/dictionary"
require "postscript/lexer"
require "postscript/mark"
require "postscript/source"
require "postscript/operator"
require "postscript/operators"
require "postscript/procedure"
require "postscript/interpreter/context"
require "postscript/interpreter/dictionary_stack"
require "postscript/interpreter/execution_stack"
require "postscript/interpreter/global_dictionary"
require "postscript/interpreter/operator_stack"
require "postscript/interpreter/states"
require "postscript/interpreter/system_dictionary"
require "postscript/interpreter/user_dictionary"

module PostScript

  class Interpreter
    include Support::StateMachine
    include States

    class StackUnderflowError < StandardError; end

    # The current operator stack.
    attr_reader :stack

    # The current dictionary stack.
    attr_reader :dictionary_stack

    # The current execution stack.
    attr_reader :execution_stack

    def initialize(*extensions)
      @stack = OperatorStack.new
      @dictionary_stack = DictionaryStack.new
      @execution_stack = ExecutionStack.new

      @dictionary_stack.push \
        SystemDictionary,
        GlobalDictionary,
        *extensions,
        UserDictionary.new
    end

    def eval(data)
      source = Source.new(data)
      execution_stack.push source

      run
    end

    def run
      until execution_stack.empty?
        @last_token = execution_stack.next_token
        machine.trigger __state__, @last_token
      end
    rescue => exception
      exception.message << "\n\n#{inspect}"

      raise
    end

    def __state__
      @__state__ ||= Context.new(self)
    end

    def inspect
      "#<PostScript::Interpreter \n  %17s=%s\n  %17s=%s\n  %17s=%s\n  %17s=%s\n  %17s=%s\n>" % [
        "@last_token", @last_token.inspect,
        "@stack", @stack.inspect,
        "@dictionary_stack", @dictionary_stack.inspect,
        "@execution_stack", @execution_stack.inspect,
        "@state", __state__.inspect
      ]
    end
  end

end
