module PostScript
  class Dictionary < Hash

    def self.operators
      @operators ||= {}
    end

    def self.operator(name, signature = nil, &block)
      operators[name] = Operator.new(name, signature, &block)
    end

    def initialize(size = nil)
      @size = size

      super()
      update self.class.operators
    end

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
