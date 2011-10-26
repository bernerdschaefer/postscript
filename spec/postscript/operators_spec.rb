require "spec_helper"

describe PostScript::Operators do

  let(:runtime) do
    Class.new do
      include PostScript::Operators

      def stack
        @stack ||= []
      end

      def push(element)
        stack.push element
      end
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

end
