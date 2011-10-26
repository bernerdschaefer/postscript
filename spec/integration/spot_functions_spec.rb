require "spec_helper"

describe PostScript::Runtime do
  let(:runtime) do
    described_class.new
  end

  # Integration tests based on the PDF implementation's Spot Functions defined
  # in Table 128 of the PDF Spec.

  context "PDF Spot Functions" do
    # Spot functions always begin with a two-element [x, y] stack.
    let(:x) { 4.0 }
    let(:y) { 2.0 }

    let(:result) do
      runtime.push x
      runtime.push y
      runtime.eval function
      runtime.stack
    end

    describe "SimpleDot" do
      let(:function) { "{ dup mul exch dup mul add 1 exch sub }" }

      it "produces the correct results" do
        result.should eq [1 - (x ** 2 + y ** 2)]
      end
    end

    describe "InvertedSimpleDot" do
      let(:function) { "{dup mul exch dup mul add 1 sub}" }

      it "produces the correct results" do
        result.should eq [x**2 + y**2 - 1]
      end
    end

    describe "DoubleDot" do
      let(:function) { "{ 360 mul sin 2 div exch 360 mul sin 2 div add }" }

      it "produces the correct results" do
        result.should eq [Math.sin(360 * x) / 2 + Math.sin(360 * y) / 2]
      end
    end

    describe "InvertedDoubleDot" do
      let(:function) { "{ 360 mul sin 2 div exch 360 mul sin 2 div add neg }" }

      it "produces the correct results" do
        result.should eq [-(Math.sin(360 * x) / 2 + Math.sin(360 * y) / 2)]
      end
    end

    describe "CosineDot" do
      let(:function) { "{ 180 mul cos exch 180 mul cos add 2 div }" }

      it "produces the correct results" do
        result.should eq [Math.cos(180 * x) / 2 + Math.cos(180 * y) / 2]
      end
    end

    describe "Double" do
      let(:function) { "{ 360 mul sin 2 div exch 2 div 360 mul sin 2 div add }" }

      it "produces the correct results" do
        output = Math.sin(360 * (x / 2)) / 2
        output += Math.sin(360 * y) / 2
        result.should eq [output]
      end
    end

    describe "InvertedDouble" do
      let(:function) { "{ 360 mul sin 2 div exch 2 div 360 mul sin 2 div add neg }" }

      it "produces the correct results" do
        output = Math.sin(360 * (x / 2)) / 2
        output += Math.sin(360 * y) / 2
        output *= -1
        result.should eq [output]
      end
    end

    describe "Line" do
      let(:function) { "{ exch pop abs neg }" }

      it "produces the correct results" do
        result.should eq [-y.abs]
      end
    end

    describe "LineX" do
      let(:function) { "{ pop }" }

      it "produces the correct results" do
        result.should eq [x]
      end
    end

    describe "LineY" do
      let(:function) { "{ exch pop }" }

      it "produces the correct results" do
        result.should eq [y]
      end
    end

    describe "EllipseA" do
      let(:function) { "{ dup mul 0.9 mul exch dup mul add 1 exch sub}" }

      it "produces the correct results" do
        result.should eq [1 - (x**2 + 0.9 * y**2)]
      end
    end

    describe "InvertedEllipseA" do
      let(:function) { "{ dup mul 0.9 mul exch dup mul add 1 sub}" }

      it "produces the correct results" do
        result.should eq [(x**2 + 0.9 * y**2) - 1]
      end
    end

    describe "EllipseB" do
      let(:function) { "{ dup 5 mul 8 div mul exch dup mul exch add sqrt 1 exch sub }" }

      it "produces the correct results" do
        out = 1
        out -= Math.sqrt(x**2 + (5.0/8) * y**2)
        result.should eq [out]
      end
    end

    describe "EllipseC" do
      let(:function) { "{ dup mul exch dup mul 0.9 mul add 1 exch sub }" }

      it "produces the correct results" do
        out = 1
        out -= 0.9 * x**2 + y**2
        result.should eq [out]
      end
    end

    describe "InvertedEllipseC" do
      let(:function) { "{ dup mul exch dup mul 0.9 mul add 1 sub }" }

      it "produces the correct results" do
        out = 0.9 * x**2 + y**2
        out -= 1
        result.should eq [out]
      end
    end

    describe "InvertedEllipseC" do
      let(:function) { "{ dup mul exch dup mul 0.9 mul add 1 sub }" }

      it "produces the correct results" do
        out = 0.9 * x**2 + y**2
        out -= 1
        result.should eq [out]
      end
    end

    describe "Square" do
      let(:x) { -4.0 }
      let(:function) { "{ abs exch abs 2 copy lt { exch } if pop neg }" }

      it "produces the correct results" do
        result.should eq [-[x.abs, y.abs].max]
      end
    end

    describe "Cross" do
      let(:x) { -4.0 }
      let(:function) { "{ abs exch abs 2 copy gt { exch } if pop neg }" }

      it "produces the correct results" do
        result.should eq [-[x.abs, y.abs].min]
      end
    end

    describe "Rhomboid" do
      let(:x) { -4.0 }
      let(:function) { "{ abs exch abs 0.9 mul add 2 div }" }

      it "produces the correct results" do
        result.should eq [(0.9 * x.abs + y.abs) / 2]
      end
    end
  end

end
