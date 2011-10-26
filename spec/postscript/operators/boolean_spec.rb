require "spec_helper"

describe PostScript::Operators::Boolean do

  let(:runtime) do
    Class.new(TestRuntime) do
      include PostScript::Operators::Stack
      include PostScript::Operators::Boolean
    end.new
  end

  describe "#eq" do
    context "when elements are equal" do
      before do
        runtime.push 1, 1
      end

      it "returns true" do
        runtime.eq
        runtime.stack.should eq [true]
      end
    end

    context "when elements are equal" do
      before do
        runtime.push 2, 1
      end

      it "returns false" do
        runtime.eq
        runtime.stack.should eq [false]
      end
    end
  end

  describe "#ne" do
    context "when elements are equal" do
      before do
        runtime.push 1, 1
      end

      it "returns false" do
        runtime.ne
        runtime.stack.should eq [false]
      end
    end

    context "when elements are equal" do
      before do
        runtime.push 2, 1
      end

      it "returns true" do
        runtime.ne
        runtime.stack.should eq [true]
      end
    end
  end

  describe "#gt" do
    before do
      runtime.push 3, 1
    end

    it "tests greater than" do
      runtime.gt.should eq [true]
    end
  end

  describe "#ge" do
    before do
      runtime.push 2, 2
    end

    it "tests greater than or equal" do
      runtime.ge.should eq [true]
    end
  end

  describe "#lt" do
    before do
      runtime.push 3, 1
    end

    it "tests less than" do
      runtime.lt.should eq [false]
    end
  end

  describe "#le" do
    before do
      runtime.push 2, 2
    end

    it "tests less than or equal" do
      runtime.le.should eq [true]
    end
  end

  describe "#and" do
    context "with booleans" do
      before do
        runtime.push true, false
      end

      it "performs a logical and" do
        runtime.and.should eq [false]
      end
    end

    context "with numbers" do
      before do
        runtime.push 3, 2
      end

      it "performs a bitwise and" do
        runtime.and.should eq [2]
      end
    end
  end

  describe "#or" do
    context "with booleans" do
      before do
        runtime.push true, false
      end

      it "performs a logical or" do
        runtime.or.should eq [true]
      end
    end

    context "with numbers" do
      before do
        runtime.push 3, 2
      end

      it "performs a bitwise or" do
        runtime.or.should eq [3]
      end
    end
  end

  describe "#xor" do
    context "with booleans" do
      before do
        runtime.push true, true
      end

      it "performs a logical xor" do
        runtime.xor.should eq [false]
      end
    end

    context "with numbers" do
      before do
        runtime.push 3, 2
      end

      it "performs a bitwise xor" do
        runtime.xor.should eq [1]
      end
    end
  end

  describe "#not" do
    context "with booleans" do
      before do
        runtime.push true
      end

      it "performs a logical not" do
        runtime.not.should eq [false]
      end
    end

    context "with numbers" do
      before do
        runtime.push 3
      end

      it "performs a bitwise not" do
        runtime.not.should eq [-4]
      end
    end
  end

end
