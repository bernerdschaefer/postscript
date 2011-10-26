require "stringio"

module PostScript
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
