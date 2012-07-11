require "active_support/concern"

module PostScript
  class Lexer
    module States
      extend ActiveSupport::Concern

      included do
        whitespace = /[\r\n\t\f\0 ]/
        special    = /[\r\n\t\f\0 \[\]\{\}\/\<\>%]/
        nonspecial = /[^\r\n\t\f\0 \[\]\{\}\/\<\>%]/
        hex_digit  = /[[:xdigit:]]/
        digit      = /[[:digit:]]/
        newline    = /[\r\n]/
        exponent   = /e/i
        character_code = /[0-7]/
        any        = //

        capture = ->(context, value) { context[:value] << value unless value == :eof }

        ungetc = ->(context, value) { context[:source].ungetc value unless value == :eof }

        done = ->(context, _) { context.trigger :done }

        append = ->(value) do
          ->(context, _) { context[:value] << value }
        end

        token = ->(type, *args) do
          ->(context, _) do
            if type && type.is_a?(Class)
              context[:token] = type.new(context[:value], *args)
            else
              context[:token] = type
            end

            context.transition :token
          end
        end

        forward = ->(state) do
          ->(context, value) do
            context.transition state
            context.trigger value
          end
        end

        transition = ->(state) do
          ->(context, _) { context.transition state }
        end

        state :default do
          on "{",  capture, token[Lexer::Types::Name, executable: true, immediate: true]
          on "}",  capture, token[Lexer::Types::Name, executable: true, immediate: true]
          on "[",  capture, token[Lexer::Types::Name, executable: true]
          on "]",  capture, token[Lexer::Types::Name, executable: true]

          on "/",  transition[:literal_name_or_immediately_executable_name]
          on "<",  transition[:dicionary_start_or_special_string]
          on ">",  capture, transition[:dictionary_end]
          on "%",  transition[:comment]
          on "(",  transition[:literal_string]

          on ".", capture, transition[:remainder_prefix]
          on "+", "-", capture, transition[:numeric_prefix]
          on digit, capture, transition[:number]

          on :eof, transition[:eof]
          on whitespace

          on any, capture, transition[:executable_name]
        end

        state :executable_name do
          on nonspecial, capture
          on special, ungetc, done

          on :eof, :done, token[Lexer::Types::Name, executable: true]
        end

        state :dicionary_start_or_special_string do
          on "<", append["<<"], transition[:executable_name]
          on "~", transition[:base85_string]
          on any,  forward[:hex_string]
        end

        state :base85_string do
          base85_character = /[!-u]/
          on "~", transition[:base85_string_awaiting_close]
          on base85_character do
            raise NotImplementedError, "base85 encoded strings are not supported"
          end
        end

        state :base85_string_awaiting_close do
          on ">", token[String]
        end

        state :hex_string do
          on hex_digit, capture

          on ">", token[Lexer::Types::HexString]
        end

        state :dictionary_end do
          on ">", capture, transition[:executable_name]
        end

        state :comment do
          on newline, transition[:default]
          on any
          on :eof, transition[:default]
        end

        state :literal_name_or_immediately_executable_name do
          on "/", transition[:immediately_executable_name]
          on any, :eof, forward[:literal_name]
        end

        state :immediately_executable_name do
          on nonspecial, capture
          on special, ungetc, done
          on :eof, :done, token[Lexer::Types::Name, executable: true, immediate: true]
        end

        state :literal_name do
          on nonspecial, capture
          on special, ungetc, done
          on :eof, :done, token[Lexer::Types::Name]
        end

        state :literal_string do
          on ")" do |context|
            if (nesting = context[:nesting]) && nesting > 0
              capture[context, ")"]
              context[:nesting] -= 1
            else
              context.trigger :done
            end
          end

          on "(", capture do |context|
            context[:nesting] ||= 0
            context[:nesting] += 1
          end

          on "\\", transition[:literal_string_escape]
          on any,  capture
          on :done, token[String]
        end

        state :literal_string_escape do
          on "(",  capture, transition[:literal_string]
          on ")",  capture, transition[:literal_string]
          on "n",  append["\n"], transition[:literal_string]
          on "r",  append["\r"], transition[:literal_string]
          on "t",  append["\t"], transition[:literal_string]
          on "b",  append["\b"], transition[:literal_string]
          on "f",  append["\f"], transition[:literal_string]
          on "\\", append["\\"], transition[:literal_string]
          on "\n", transition[:literal_string]
          on character_code, forward[:literal_string_character_code_escape]
          on any,   capture, transition[:literal_string]
        end

        state :literal_string_character_code_escape do
          on character_code do |context, value|
            code = (context[:character_code_escape] ||= "")

            if code.length < 3
              context[:character_code_escape] << value
            else
              ungetc[context, value]
              context.trigger :done
            end
          end

          on any, ungetc, done

          on :done do |context|
            context[:value] << context[:character_code_escape].to_i(8).chr
            context.transition :literal_string
          end
        end

        state :numeric_prefix do
          on digit, capture, transition[:number]
          on ".", capture, transition[:remainder]

          on any, :eof, capture, transition[:executable_name]
        end

        state :number do
          on digit, capture
          on ".",  capture, transition[:remainder]
          on exponent, capture, transition[:exponent_prefix]
          on "#", capture, transition[:radix_number]

          on special, :eof, ungetc, done
          on :done, token[Lexer::Types::Integer]

          on any, capture, transition[:executable_name]
        end

        state :remainder_prefix do
          on digit, capture, transition[:remainder]
          on any, :eof, capture, transition[:executable_name]
        end

        state :remainder do
          on digit, capture
          on exponent, capture, transition[:exponent_prefix]
          on special, :eof, ungetc, done
          on :done, token[Lexer::Types::RealNumber]

          on any, capture, transition[:executable_name]
        end

        state :exponent_prefix do
          on "-", "+", digit, capture, transition[:exponent]
          on any, capture, transition[:executable_name]
        end

        state :exponent do
          on digit, capture
          on special, :eof, ungetc, done
          on :done, token[Lexer::Types::RealNumber]

          on any, capture, transition[:executable_name]
        end

        state :radix_number do
          on hex_digit, capture
          on special, :eof, ungetc, done
          on :done, token[Lexer::Types::RadixNumber]

          on any, capture, transition[:executable_name]
        end

      end
    end
  end
end
