require "spec_helper"

describe PostScript::Operators do

  it "includes PostScript::Operators::Stack" do
    described_class.ancestors.should include PostScript::Operators::Stack
  end

  it "includes PostScript::Operators::Arithmetic" do
    described_class.ancestors.should include PostScript::Operators::Arithmetic
  end

  it "includes PostScript::Operators::Boolean" do
    described_class.ancestors.should include PostScript::Operators::Boolean
  end

  it "includes PostScript::Operators::Conditional" do
    described_class.ancestors.should include PostScript::Operators::Conditional
  end

end
