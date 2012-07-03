require "postscript/name"

require "postscript/lexer/state_machine"
require "postscript/lexer/types"
require "postscript/lexer/states"

module PostScript
  class Lexer
    include StateMachine
    include States

    def next_token(source)
      context = Context.new :default,
        token: nil,
        value: "",
        source: source

      until [:token, :eof].include? context.state
        machine.trigger context, source.getc
      end

      if context.state == :eof
        :eof
      else
        context[:token]
      end
    end

  end
end
