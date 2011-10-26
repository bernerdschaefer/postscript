require "spec_helper"

describe PostScript::Operators do

  it "includes PostScript::Operators::Stack" do
    described_class.ancestors.should include PostScript::Operators::Stack
  end

end
