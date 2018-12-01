require "rspec"
require_relative "./day_1"

describe DeviceCalibration do
  it "calculates frequency drift for a given input" do
    [
      [[+1, +1, +1], 3],
      [[+1, +1, -2], 0],
      [[-1, -2, -3], -6],
      [[+1, -2, +3, +1], 3]
    ].each do |input, result|
      expect(described_class.new(input).frequency_drift).to eq result
    end
  end

  it "calibrates itself" do
    [
      [[+1, -2, +3, +1], 2],
      [[+1, -1], 0],
      [[+3, +3, +4, -2, -4], 10],
      [[-6, +3, +8, +5, -6], 5],
      [[+7, +7, -2, -7, -4], 14]
    ].each do |input, result|
      expect(described_class.new(input).calibrate).to eq result
    end
  end
end
