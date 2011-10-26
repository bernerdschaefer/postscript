require "spec_helper"

describe PostScript::Operators::Stack do

  let(:runtime) do
    Class.new(TestRuntime) do
      include PostScript::Operators::Stack
    end.new
  end

  describe "#pop" do
    before do
      runtime.push 0
      runtime.push 1
    end

    it "returns the last element from the stack" do
      runtime.pop.should eq 1
    end

    it "removes the last element from the stack" do
      runtime.pop
      runtime.stack.should eq [0]
    end
  end

  describe "#dup" do
    before do
      runtime.push 0
      runtime.push 1
    end

    it "duplicates the last element onto the end of the stack" do
      runtime.dup
      runtime.stack.should eq [0, 1, 1]
    end
  end

  describe "#copy" do
    before do
      runtime.push 10
      runtime.push 20
    end

    it "duplicates the last n items" do
      runtime.push 2
      runtime.copy
      runtime.stack.should eq [10, 20, 10, 20]
    end
  end

  describe "#exch" do
    before do
      runtime.push 0
      runtime.push 1
    end

    it "swaps the last two elements on the stack" do
      runtime.exch
      runtime.stack.should eq [1, 0]
    end
  end

  describe "#index" do
    before do
      runtime.push 10
      runtime.push 20
    end

    it "copies the nth element onto the stack" do
      runtime.push 0
      runtime.index
      runtime.stack.should eq [10, 20, 10]
    end
  end

  describe "#roll" do
    before do
      runtime.push 0
      runtime.push 10
      runtime.push 20
      runtime.push 30
    end

    context "j is positive" do
      it "rolls n elements up the stack j times" do
        runtime.push 2, 1
        runtime.roll
        runtime.stack.should eq [30, 0, 10, 20]
      end
    end

    context "j is negative" do
      it "rolls n elements down the stack j times" do
        runtime.push 2, -2
        runtime.roll
        runtime.stack.should eq [20, 30, 0, 10]
      end
    end
  end

end
