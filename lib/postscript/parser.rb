require "stringio"

module PostScript

  # The parser is responsible for normalizing and tokenizing a given string of
  # PostScript text.
  #
  # It supports the following types: floats, integers, boolean, procedures, and
  # operators.
  #
  # The output of the parser is always an array of these types, where floats,
  # integers, and boolean types are represented by their native ruby types
  # (1.0, -4, true, false), procedures by arrays, and operators by symbols.
  #
  # @example Simple parsing
  #
  #     PostScript::Parser.parse("{ 2 2 mul 2 div }")
  #     # => [2, 2, :mul, 2, :div]
  #
  # @example Nested procedures
  #
  #     PostScript::Parser.parse "{ 4 5 gt { exch } if pop }"
  #     # => [ 4, 5, :gt, [ :exch ], :if, :pop ]
  #
  class Parser

    class << self

      # Parses the provided source code and returns the parsed procedure.
      #
      # @param [String] source the PostScript source code
      # @return [Array] the parsed procedure
      def parse(source)
        new(source).parse
      end

    end

    # @return [String] the PostScript source code
    attr_reader :source

    # Initializes a new parser with the provided PostScript source.
    #
    # @param [String] source a bit of PostScript to parse
    def initialize(source)
      @source = normalize(source)
    end

    # Parses the source code and returns the parsed procedure.
    #
    # @return [Array] the parsed procedure
    def parse
      tokens = source.split(/([{} ])/)

      parse_procedure(tokens)
    end

    # Removes leading and trailing whitespace, collapses inner whitespaces into
    # a single space, and wraps the source in curly braces if not present.
    #
    # @param [String] source a bit of PostScript source code
    # @return [String] the normalized source code
    def normalize(source)
      source = source.strip

      if source[0] == "{"
        source = source[1..-1].lstrip
      end

      if source[-1] == "}"
        source = source[0...-1].rstrip
      end

      source = source.gsub /\s+/, " "

      source
    end

    private

    # Recursively parses a PostScript procedure from a list of tokens.
    #
    # @param [Array] tokens the tokenized source
    # @return [Array] the parsed procedure
    def parse_procedure(tokens)
      procedure = []

      while token = tokens.shift
        case token
        when "", " "
          next
        when "{"
          procedure << parse_procedure(tokens)
        when "}"
          break
        when /^ -? [0-9]+ $/x
          procedure.push Integer(token)
        when /^ -? [0-9]+ \. [0-9]+ $/x
          procedure.push Float(token)
        when "true"
          procedure.push true
        when "false"
          procedure.push false
        else
          procedure.push token.to_sym
        end
      end

      procedure
    end

  end
end
