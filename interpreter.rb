class DecodeStream
  def initialize(source, r=55665, n=4)
    @source = source
    @r = r
    @n = n

    @c1 = 52845
    @c2 = 22719
  end

  def getc
    cipher = @source.getbyte

    plain = (cipher ^ (@r >> 8)) & 0xFF
    @r = ((cipher + @r) * @c1 + @c2) & 0xFFFF
    plain.chr
  end

  def read(length, target="")
    target.clear
    length.times { target << getc }
    target
  end
end

class SystemDictionary
  def eexec
    stream = pop

    decode_stream = DecodeStream.new(stream)
    decode_stream.on_close = -> { dictionary_stack.pop }
    execution_stack.push decode_stream
    dictionary_stack.push system_dictionary
  end
end

class Interpreter
  def initialize(*extensions)
    @system_dictionary = SystemDictionary.new

    extend *extensions
  end

  def extend(*extensions)
    system_dictionary.extend *extensions
  end
end

module Type1Fonts
  def definefont

  end
end

ps = PostScript::Runtime.new
# ps.extend PostScript::Type1Fonts
ps.run "~/code/hoth/F20.pfa"
