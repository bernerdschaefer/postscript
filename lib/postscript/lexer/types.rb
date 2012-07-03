module PostScript
  class Lexer
    module Types
      Name = PostScript::Name

      class HexString
        def self.new(string)
          [string].pack("H*")
        end
      end

      class RadixNumber
        def self.new(chars)
          value = chars
          base, number = value.split "#"

          number.to_i(base.to_i)
        end
      end

      class RealNumber
        def self.new(chars)
          chars.to_f
        end
      end

      class Integer
        def self.new(chars)
          chars.to_i
        end
      end
    end
  end
end
