require_relative "./day_5"

describe AlchemicalReductor do
  let(:input) { "dabAcCaCBAcCcaDA" }

  it "performs all the reductions" do
    expect(AlchemicalReductor.perform(input)).to eq 10
  end

  it "optimizes the reductions" do
    expect(AlchemicalReductor.perform_optimal(input)).to eq 4
  end
end
