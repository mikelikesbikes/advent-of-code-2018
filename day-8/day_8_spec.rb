require_relative "./day_8"

describe LicenseCracker do
  let(:input) do
    "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
  end

  it "sums all the metadata" do
    expect(LicenseCracker.metadata_sum(input)).to eq 138
  end

  it "calculates a value" do
    expect(LicenseCracker.calculate_value(input)).to eq 66
  end
end
