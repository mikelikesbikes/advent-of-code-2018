require_relative "./day_6"

describe SpatialAnalyzer do
  let(:input) do
    [
      "1, 1",
      "1, 6",
      "8, 3",
      "3, 4",
      "5, 5",
      "8, 9"
    ]
  end

  it "calculates the safest cell's area" do
    expect(SpatialAnalyzer.safest_area(input)).to eq 17
  end

  it "calculates the nearest region's area" do
    expect(SpatialAnalyzer.nearest_area(input, 32)).to eq 16
  end
end
