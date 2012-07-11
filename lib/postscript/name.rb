module PostScript
  class Name < String
    attr_reader :executable, :immediate

    def initialize(string, flags = {})
      super(string)

      @executable = flags.fetch(:executable, false)
      @immediate  = flags.fetch(:immediate, false)
    end

    def ==(other)
      self.class === other && super && executable == other.executable && immediate == other.immediate
    end

    def inspect
      case
      when immediate then "//#{to_s}"
      when executable then to_s
      else "/#{to_s}"
      end
    end
  end
end
