require "spec_helper"

describe PostScript::Runtime do

  let(:runtime) { PostScript::Runtime.new }

  it "should include PostScript::Operators" do
    PostScript::Runtime.ancestors.should include PostScript::Operators
  end

  describe "#stack" do
    it "returns an array" do
      runtime.stack.should be_an Array
    end

    it "is memoized" do
      runtime.stack << 1
      runtime.stack.should eq [1]
    end
  end

  describe "#push" do
    it "adds the element to the stack" do
      runtime.push 1
      runtime.stack.should eq [1]
    end
  end

end
