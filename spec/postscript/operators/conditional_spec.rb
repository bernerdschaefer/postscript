require "spec_helper"

describe PostScript::Operators::Conditional do

  let(:runtime) do
    PostScript::Runtime.new
  end

  describe "#if" do

    context "when true" do
      before do
        runtime.push true
        runtime.push [ 1 ]
      end

      it "executes the procedure" do
        runtime.if.should eq [ 1 ]
      end
    end

    context "when false" do
      before do
        runtime.push 0, false, [ 1 ]
      end

      it "does not execute the procedure" do
        runtime.if.should eq [ 0 ]
      end
    end

  end

  describe "#ifelse" do

    context "when true" do
      before do
        runtime.push true, [ 1 ], [ 0 ]
      end

      it "executes the first procedure" do
        runtime.ifelse.should eq [ 1 ]
      end
    end

    context "when false" do
      before do
        runtime.push false, [ 1 ], [ 0 ]
      end

      it "executes the second procedure" do
        runtime.ifelse.should eq [ 0 ]
      end
    end

  end

end
