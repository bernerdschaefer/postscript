require "spec_helper"

describe PostScript::Lexer do
  let(:lexer) { PostScript::Lexer.new }
  let(:source) { PostScript::Source.new(example.description) }
  let(:next_token) { lexer.next_token(source) }

  let(:tokens) do
    tokens = []
    while (token = lexer.next_token(source)) != :eof
      tokens << token
    end
    tokens
  end

  # Hack: update the example's description to the dumped version, so it looks
  # like when running with the documentation formatter.
  after do
    example.description.replace(example.description.dump)
  end

  # type helpers

  def name(string)
    PostScript::Name.new(string)
  end

  def executable_name(string)
    PostScript::Name.new(string, executable: true)
  end

  def immediately_executable_name(string)
    PostScript::Name.new(string, executable: true, immediate: true)
  end

  # cases

  context "eof" do
    specify(" ") { next_token.should eq :eof }
  end

  context "procedure start" do
    specify("{") { next_token.should eq executable_name("{") }
  end

  context "procedure end" do
    specify("}") { next_token.should eq executable_name("}") }
  end

  context "array start" do
    specify("[") { next_token.should eq executable_name("[") }
  end

  context "array end" do
    specify("]") { next_token.should eq executable_name("]") }
  end

  context "comment" do
    specify("% comment") { next_token.should eq :eof }
  end

  context "dictionary start" do
    specify("<<") { next_token.should eq executable_name("<<") }
  end

  context "dictionary end" do
    specify(">>") { next_token.should eq executable_name(">>") }
  end

  context "executable name" do
    specify("name")   { next_token.should eq executable_name("name") }
    specify("$$")     { next_token.should eq executable_name("$$") }
    specify("$$/abc") { next_token.should eq executable_name("$$") }
  end

  context "literal name" do
    specify("/")      { next_token.should eq name("") }
    specify("/name")  { next_token.should eq name("name") }
    specify("/name ") { next_token.should eq name("name") }
  end

  context "immediately executable name" do
    specify("//")      { next_token.should eq immediately_executable_name("") }
    specify("//name")  { next_token.should eq immediately_executable_name("name") }
    specify("//name ") { next_token.should eq immediately_executable_name("name") }
  end

  context "literal name with immediately executable name" do
    specify("/name //name") do
      tokens.should eq [name("name"), immediately_executable_name("name")]
    end

    specify("/name//name") do
      tokens.should eq [name("name"), immediately_executable_name("name")]
    end

    specify("/name//name/name") do
      tokens.should eq [
        name("name"),
        immediately_executable_name("name"),
        name("name")
      ]
    end
  end

  context "hex string" do
    specify("<>")       { next_token.should eq "" }
    specify("<901fa3>") { next_token.should eq ["901fa3"].pack("H*") }
    specify("<901fa>")  { next_token.should eq ["901fa"].pack("H*") }
  end

  context "base 85 encoded string" do
    specify("<~~>")   { next_token.should eq "" }
    specify("<~!u~>") { expect { next_token }.to raise_exception(NotImplementedError) }
  end

  context "literal string" do
    specify("()") { next_token.should eq "" }
    specify("(string)") { next_token.should eq "string" }
  end

  context "nested literal string" do
    specify("(str(ing))") { next_token.should eq "str(ing)" }
  end

  context "literal string with escaped characters" do
    specify("(str\\(ing)")  { next_token.should eq "str(ing" }
    specify("(str\\)ing)")  { next_token.should eq "str)ing" }
    specify("(str\\ning)")  { next_token.should eq "str\ning" }
    specify("(str\\ring)")  { next_token.should eq "str\ring" }
    specify("(str\\ting)")  { next_token.should eq "str\ting" }
    specify("(str\\bing)")  { next_token.should eq "str\bing" }
    specify("(str\\fing)")  { next_token.should eq "str\fing" }
    specify("(str\\\\ing)") { next_token.should eq "str\\ing" }
    specify("(str\\\ning)") { next_token.should eq "string" }
    specify("(str\\ing)")   { next_token.should eq "string" }
  end

  context "literal string with escaped character codes" do
    specify("(str\\0ing)")   { next_token.should eq "str\0ing" }
    specify("(str\\00ing)")  { next_token.should eq "str\0ing" }
    specify("(str\\000ing)") { next_token.should eq "str\0ing" }
    specify("(str\\1ing)")   { next_token.should eq "str\1ing" }
    specify("(str\\01ing)")  { next_token.should eq "str\1ing" }
    specify("(str\\001ing)") { next_token.should eq "str\1ing" }
    specify("(str\\45ing)")  { next_token.should eq "str\45ing" }
    specify("(str\\045ing)") { next_token.should eq "str\45ing" }
    specify("(str\\337ing)") { next_token.should eq "str\337ing" }
    specify("(str\\337)")    { next_token.should eq "str\337" }
    specify("(str\\3377)")   { next_token.should eq "str\3377" }
  end

  context "signed integers" do
    specify("123") { next_token.should eq 123 }
    specify("-98") { next_token.should eq -98 }
    specify("0")   { next_token.should eq 0 }
    specify("+17") { next_token.should eq 17 }
    specify("43445") { next_token.should eq 43445 }
  end

  context "radix numbers" do
    specify("8#1777")  { next_token.should eq "1777".to_i(8) }
    specify("16#FFFE") { next_token.should eq "FFFE".to_i(16) }
    specify("2#1000")  { next_token.should eq "1000".to_i(2) }
  end

  context "real numbers" do
    specify("-.002")  { next_token.should eq -0.002 }
    specify("34.5")   { next_token.should eq 34.5 }
    specify("-3.62")  { next_token.should eq -3.62 }
    specify("1.0E-5") { next_token.should eq 1.0E-5 }
    specify("1E6")    { next_token.should eq 1E6 }
    specify("-1.")    { next_token.should eq -1.0 }
    specify("0.0")    { next_token.should eq 0.0 }
    specify("123.6e10") { next_token.should eq 123.6e10 }
  end

  context "executable names that look like numbers:" do
    specify("1.34a") { next_token.should eq executable_name("1.34a") }
    specify("1a")    { next_token.should eq executable_name("1a") }
    specify("1#FZ")  { next_token.should eq executable_name("1#FZ") }
    specify("1e4a")  { next_token.should eq executable_name("1e4a") }
    specify("1e++1") { next_token.should eq executable_name("1e++1") }
    specify("+")     { next_token.should eq executable_name("+") }
    specify("-")     { next_token.should eq executable_name("-") }
    specify(".")     { next_token.should eq executable_name(".") }
    specify("+a")    { next_token.should eq executable_name("+a") }
    specify("-a")    { next_token.should eq executable_name("-a") }
    specify(".a")    { next_token.should eq executable_name(".a") }
  end

end
