require "active_support/concern"

module PostScript
  class Interpreter
    module States
      extend ActiveSupport::Concern

      executable_name = Module.new do
        def self.===(other)
          other.is_a?(Name) && other.executable
        end
      end

      immediate_name = Module.new do
        def self.===(other)
          other.is_a?(Name) && other.immediate
        end
      end

      included do
        state :default do
          on :eof do |context, token|
            context.execution_stack.pop
          end

          on Operator, Procedure do |context, operator|
            operator.call(context)
          end

          on executable_name do |context, name|
            context.trigger context.dictionary_stack[name]
          end

          on Object do |context, token|
            context.stack.push token
          end
        end

        state :scan_procedure do
          on "}" do |context, name|
            context.dictionary_stack[name].call(context)
          end

          on immediate_name do |context, name|
            context.trigger context.dictionary_stack[name]
          end

          on Object do |context, token|
            context.stack.push token
          end
        end

      end
    end
  end
end
