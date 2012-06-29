module PostScript
  class Scanner

    WHITESPACE = "\x00" "\t" "\r" "\n" "\f" " "

    COMMENT = "%" ... "\r\n\f"

    # numbers:
    #   123 −98 43445 0 +17
    #   −.002 34.5 −3.62 123.6e10 1.0E−5 1E6 −1. 0.0
    #   8#1777 16#FFFE 2#1000
    #
    # literal string:
    #   (abc (de))
    #   (abc \ndef)
    #
    # hexadecimal strings:
    #   <901fa3>
    #   <901fa>
    #
    # ascii base65:
    #   <~ ... ~>
    #
    # executable names:
    #   abc Offset $$ 23A 13−456 a.b $MyDict @pattern
    #
    # literal names:
    #   /
    #   /asdcasdcasdc
    #
    # immediately evaluated name:
    #   //asdcasdc
    #
    # array
    #   []
    #
    # procedure
    #   { a b /asdc }
    #
    # dictionary
    #   << key value >>

    def initialize(source)
      @source = source
      @state = nil
    end

    def token
      token = ""

      loop do
        return nil unless char = @source.getch

        case char

          when "/"

        end
      end
    end
  end
end
