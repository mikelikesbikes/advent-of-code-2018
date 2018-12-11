require_relative "./day_11.rb"

describe FuelIndicator do
  describe "#fuel_level" do
    [
      [8, [3, 5], 4],
      [57, [122, 79], -5],
      [39, [217, 196], 0],
      [71, [101, 153], 4]
    ].each do |serial_number, (x, y), expected_fuel_level|
      it "calculates the fuel level for the 1x1 square at #{x}, #{y} with serial_number #{serial_number}" do
        expect(FuelIndicator.new(8).fuel_level(3, 5)).to eq 4
        expect(FuelIndicator.new(57).fuel_level(122, 79)).to eq -5
        expect(FuelIndicator.new(39).fuel_level(217, 196)).to eq 0
        expect(FuelIndicator.new(71).fuel_level(101, 153)).to eq 4
      end
    end
  end

  [
    [18, 3, [33, 45]],
    [18, 16, [90, 269]],
    [42, 12, [232, 251]]
  ].each do |(serial_number, size, expected_coord)|
    it "finds the #{size}x#{size} square with the largest total power for grid with serial number #{serial_number}" do
      expect(FuelIndicator.new(serial_number).largest_total_power_block_for_size(size).first).to eq expected_coord
    end
  end

  [
    [18, [90,269,16]],
    [42, [232,251,12]]
  ].each do |serial_number, expected_power_and_size|
    it "finds the arbitrarily sized square with the largest total power for grid with serial number #{serial_number}" do
      expect(FuelIndicator.new(serial_number).largest_total_power_block).to eq expected_power_and_size
    end
  end
end
