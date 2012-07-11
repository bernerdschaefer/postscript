module PostScript
  module Operators
    module Dictionary
      extend ActiveSupport::Concern

      included do

        operator "dict", [Integer] do |n|
          push PostScript::Dictionary.new(n)
        end

        operator "<<" do
          push PostScript::Dictionary.new
        end

        operator ">>" do
          operators = []

          until (value = pop).is_a?(PostScript::Dictionary)
            operators.unshift value
          end

          unless operators.length.even?
            raise "range check: dictionary does not contain key/value pairs"
          end

          dictionary = value

          operators.each_slice(2) do |key, value|
            dictionary[key] = value
          end

          push dictionary
        end

        operator "begin", [PostScript::Dictionary] do |dict|
          dictionary_stack.push dict
        end

        operator "end" do
          dictionary_stack.pop
        end

        operator "def", [Object, Object] do |key, value|
          dictionary_stack[key] = value
        end

        operator "currentdict" do
          push dictionary_stack.last
        end

        operator "known", [PostScript::Dictionary, Object] do |dict, key|
          push dict.has_key?(key)
        end

      end
    end
  end
end
