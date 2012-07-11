module PostScript
  class Dictionary < Hash

    def []=(key, value)
      super key.to_s, value
    end

    def [](key)
      super key.to_s
    end

    def has_key?(key)
      super key.to_s
    end

    def inspect
      "-dict-"
    end

  end
end
