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
    it "rolls the stack when j = -1" do
      runtime.push 1, 2, 3
      runtime.push 3, -1
      runtime.roll.should eq [2, 3, 1]
    end

    it "rolls the stack when j = 1" do
      runtime.push 1, 2, 3
      runtime.push 3, 1
      runtime.roll.should eq [3, 1, 2]
    end

    it "does not roll the stack when j = 0" do
      runtime.push 1, 2, 3
      runtime.push 3, 0
      runtime.roll.should eq [1, 2, 3]
    end

    it "rolls the stack when n is smaller than the stack length" do
      runtime.push 1, 2, 3, 4, 5
      runtime.push 3, 1
      runtime.roll.should eq [1, 2, 5, 3, 4]
    end

    it "rolls the stack when n is smaller than the stack length and j = -1" do
      runtime.push 1, 2, 3, 4, 5
      runtime.push 3, -1
      runtime.roll.should eq [1, 2, 4, 5, 3]
    end

  end

end
