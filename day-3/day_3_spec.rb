require "rspec"
require_relative "./day_3"

describe FabricAnalyzer do
  let(:input) do
    <<~INPUT.split("\n")
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
    INPUT
  end

  it "finds the number of inches of overlap" do
    expect(FabricAnalyzer.overlap(input)).to eq 4
  end

  it "finds claims that have no conflicting claims" do
    expect(FabricAnalyzer.pristine_claims(input)).to eq "#3"
  end
end
