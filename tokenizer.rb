require "stringio"

class Tokenizer

  def initialize(source)
    @source = source
  end

  def next
    buffer = ""
    state = nil

    char = @source.getch

    case char

      when "-", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        state ||= :numeric
        buffer << char

      when "."
        buffer << char

      when /\s/

        case state
        when :maybe_numeric
          Inte
        end
    end

    Integer(@source.read)
  end
end

if $0 == __FILE__
  require 'test/unit/assertions'
  include Test::Unit::Assertions

  assert_equal 10, Tokenizer.new(StringIO.new("10")).next
  assert_equal 10.5, Tokenizer.new(StringIO.new("10.5")).next
end
