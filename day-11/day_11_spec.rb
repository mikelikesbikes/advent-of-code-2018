require_relative "./day_11.rb"

describe FuelIndicator do
  it "calculates fuel level of a given cell" do
    expect(FuelIndicator.new(8).fuel_level(3, 5)).to eq 4
    expect(FuelIndicator.new(57).fuel_level(122, 79)).to eq -5
    expect(FuelIndicator.new(39).fuel_level(217, 196)).to eq 0
    expect(FuelIndicator.new(71).fuel_level(101, 153)).to eq 4
  end

  it "finds the 3x3 square with the largest total power" do
    expect(FuelIndicator.new(18).largest_total_power_block_for_size(3)).to eq [33, 45]
  end

  it "finds the square of any size with the largest total power" do
    expect(FuelIndicator.new(18).largest_total_power_block).to eq [90,269,16]
    expect(FuelIndicator.new(42).largest_total_power_block).to eq [232,251,12]
  end
end
