require "stringio"

module PostScript
  class Source < StringIO
    def getc
      super || :eof
    end
  end
end
