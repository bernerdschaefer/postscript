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

    it "accepts multiple elements to add" do
      runtime.push 1, 2
      runtime.stack.should eq [1, 2]
    end
  end

  describe "#eval" do
    let(:function) do
      "{ exch }"
    end

    it "parses the supplied function" do
      PostScript::Parser.should_receive(:parse).
        with(function).
        and_return([])

      runtime.eval function
    end

    it "evaluates the returned procedure" do
      procedure = []
      PostScript::Parser.stub(:parse => procedure)
      runtime.should_receive(:eval_procedure).with(procedure)
      runtime.eval function
    end

    it "returns the stack" do
      procedure = []
      PostScript::Parser.stub(:parse => procedure)
      runtime.should_receive(:eval_procedure).with(procedure)
      runtime.push 1.0, 2
      runtime.eval(function).should eq [1.0, 2]
    end
  end

  describe "#eval_procedure" do

    it "adds integers to the stack" do
      runtime.eval_procedure [1, 2]
      runtime.stack.should eq [1, 2]
    end

    it "adds floats to the stack" do
      runtime.eval_procedure [1.1, 2.1]
      runtime.stack.should eq [1.1, 2.1]
    end

    it "adds procedures to the stack" do
      runtime.eval_procedure [ [1, 2] ]
      runtime.stack.should eq [ [1, 2] ]
    end

    it "calls symbols" do
      runtime.should_receive :exch
      runtime.eval_procedure [ :exch ]
    end

  end

end
