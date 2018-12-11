require_relative "./day_11.rb"

describe FuelIndicator do
  let(:input) do
    ""
  end

  it "calculates fuel level of a given cell" do
    expect(FuelIndicator.fuel_level([3, 5], 8)).to eq 4
    expect(FuelIndicator.fuel_level([122, 79], 57)).to eq -5
    expect(FuelIndicator.fuel_level([217, 196], 39)).to eq 0
    expect(FuelIndicator.fuel_level([101, 153], 71)).to eq 4
  end

  it "finds the 3x3 square with the largest total power" do
    expect(FuelIndicator.largest_total_power_block(18).first).to eq [33, 45]
  end

  it "finds the square of any size with the largest total power" do
    expect(FuelIndicator.largest_total_power_block_with_size(18)).to eq [90,269,16]
    expect(FuelIndicator.largest_total_power_block_with_size(42)).to eq [232,251,12]
  end
end
