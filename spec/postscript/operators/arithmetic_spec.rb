require "spec_helper"

describe PostScript::Operators::Arithmetic do

  let(:runtime) do
    Class.new(TestRuntime) do
      include PostScript::Operators::Stack
      include PostScript::Operators::Arithmetic
    end.new
  end

  describe "#add" do
    before do
      runtime.push 2, 3
    end

    it "replaces the last two elements with their sum" do
      runtime.add
      runtime.stack.should eq [5]
    end
  end

  describe "#sub" do
    before do
      runtime.push 2, 3
    end

    it "replaces the last two elements with their difference" do
      runtime.sub
      runtime.stack.should eq [-1]
    end
  end

  describe "#mul" do
    before do
      runtime.push 2, 3
    end

    it "replaces the last two elements with their product" do
      runtime.mul
      runtime.stack.should eq [6]
    end
  end

  describe "#div" do
    context "with integers" do
      before do
        runtime.push 2, 3
      end

      it "replaces the last two elements with their quotient" do
        runtime.div
        runtime.stack.should eq [2/3]
      end
    end

    context "with real numbers" do
      before do
        runtime.push 2.0, 3.0
      end

      it "replaces the last two elements with their quotient" do
        runtime.div
        runtime.stack.should eq [2.0/3.0]
      end
    end
  end

  describe "#idiv" do
    before do
      runtime.push 6, 2
    end

    it "replaces the last two elements with their quotient" do
      runtime.idiv
      runtime.stack.should eq [3]
    end
  end

  describe "#mod" do
    before do
      runtime.push 2, 3
    end

    it "replaces the last two elements with the remainder" do
      runtime.mod
      runtime.stack.should eq [2 % 3]
    end
  end

  describe "#neg" do
    before do
      runtime.push 2
    end

    it "replaces the last element with its negated value" do
      runtime.neg
      runtime.stack.should eq [-2]
    end
  end

  describe "#abs" do
    before do
      runtime.push -2
    end

    it "replaces the last element with its absolute value" do
      runtime.abs
      runtime.stack.should eq [2]
    end
  end

  describe "#ceiling" do
    before do
      runtime.push 1.2
    end

    it "replaces the last element with its ceil'd value" do
      runtime.ceiling
      runtime.stack.should eq [2]
    end
  end

  describe "#floor" do
    before do
      runtime.push 1.2
    end

    it "replaces the last element with its floor value" do
      runtime.floor
      runtime.stack.should eq [1]
    end
  end

  describe "#round" do
    before do
      runtime.push 1.2
    end

    it "replaces the last element with its rounded value" do
      runtime.round
      runtime.stack.should eq [1.2.round]
    end
  end

  describe "#truncate" do
    before do
      runtime.push 1.2
    end

    it "replaces the last element with its truncated value" do
      runtime.truncate
      runtime.stack.should eq [1]
    end
  end

  describe "#sqrt" do
    before do
      runtime.push 3
    end

    it "replaces the last element with its square root" do
      runtime.sqrt
      runtime.stack.should eq [Math.sqrt(3)]
    end
  end

  describe "#sin" do
    before do
      runtime.push 3
    end

    it "replaces the last element with its sine" do
      runtime.sin
      runtime.stack.should eq [Math.sin(3)]
    end
  end

  describe "#cos" do
    before do
      runtime.push 3
    end

    it "replaces the last element with its cosine" do
      runtime.cos
      runtime.stack.should eq [Math.cos(3)]
    end
  end

  describe "#atan" do
    before do
      runtime.push 0, -1
    end

    it "replaces the last two elements with their arc tangent" do
      runtime.atan
      runtime.stack.should eq [Math.atan2(0, -1)]
    end
  end

  describe "#exp" do
    before do
      runtime.push 2, 3
    end

    it "raises base to the exponent power" do
      runtime.exp
      runtime.stack.should eq [ 2 ** 3 ]
    end
  end

  describe "#ln" do
    before do
      runtime.push 3
    end

    it "returns the base e logarithm" do
      runtime.ln
      runtime.stack.should eq [ Math.log(3) ]
    end
  end

  describe "#log" do
    before do
      runtime.push 3
    end

    it "returns the base 10 logarithm" do
      runtime.log
      runtime.stack.should eq [ Math.log10(3) ]
    end
  end

  describe "#cvi" do
    before do
      runtime.push 3.2
    end

    it "converts the element to an integer" do
      runtime.cvi
      runtime.stack.should eq [ 3.2.to_i ]
    end
  end

  describe "#cvr" do
    before do
      runtime.push 3
    end

    it "converts the element to a float" do
      runtime.cvr
      runtime.stack.should eq [ 3.0 ]
    end
  end

  describe "#bitshift" do
    before do
      runtime.push 7, 3
    end

    it "shifts the first element +shift+ bits" do
      runtime.bitshift.should eq [ 7 << 3 ]
    end
  end

end
