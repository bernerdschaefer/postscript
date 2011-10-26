require "spec_helper"

describe PostScript::Parser do

  describe "#initialize" do
    it "stores the source" do
      PostScript::Parser.new("exch").source.should eq "exch"
    end
  end

  describe "#normalize" do
    let(:parser) { PostScript::Parser.allocate }

    context "when called with a procedure" do
      it "removes the outer braces" do
        parser.normalize("exch").should eq "exch"
      end
    end

    context "when source has leading whitespace" do
      it "removes the whitespace" do
        parser.normalize(" \texch").should eq "exch"
      end
    end

    context "when source has trailing whitespace" do
      it "removes the whitespace" do
        parser.normalize("exch \t").should eq "exch"
      end
    end

    context "when source has interior whitespace" do
      it "collapses the whitespace" do
        parser.normalize("exch\r\n\tdup").should eq "exch dup"
      end
    end

    context "when source is not wrapped in braces" do
      it "returns the source unchanged" do
        parser.normalize("exch dup").should eq "exch dup"
      end
    end

  end

  describe "#parse" do

    context "with an empty procedure" do
      let(:parser) do
        PostScript::Parser.new "{}"
      end

      it "returns an empty array" do
        parser.parse.should eq []
      end
    end

    context "integers" do
      let(:parser) do
        PostScript::Parser.new "{ 3 4 -5 }"
      end

      it "returns an array of integers" do
        parser.parse.should eq [3, 4, -5]
      end
    end

    context "floats" do
      let(:parser) do
        PostScript::Parser.new "{ 3.0 4.0 -5.0 }"
      end

      it "returns an array of integers" do
        parser.parse.should eq [3.0, 4.0, -5.0]
      end
    end

    context "booleans" do
      let(:parser) do
        PostScript::Parser.new "{ true false }"
      end

      it "returns an array of boolean values" do
        parser.parse.should eq [ true, false ]
      end
    end

    context "operators" do
      let(:parser) do
        PostScript::Parser.new "{ exch dup }"
      end

      it "returns an array of operators" do
        parser.parse.should eq [:exch, :dup]
      end
    end

    context "single nested procedure" do
      let(:parser) do
        PostScript::Parser.new "{ 4 5 gt { exch } if pop }"
      end

      it "returns the nested procedure as an array" do
        parser.parse.should eq [4, 5, :gt, [ :exch ], :if, :pop]
      end
    end

    context "deeply nested procedure" do
      let(:parser) do
        PostScript::Parser.new "{ 4 5 gt { exch lt 0 { neg } if } if pop } if pop }"
      end

      it "returns the nested procedure as an array" do
        parser.parse.should eq \
          [4, 5, :gt, [ :exch, :lt, 0, [ :neg ], :if ], :if, :pop]
      end
    end

  end

end
