require "set"

class DeviceCalibration
  attr_reader :input
  attr_accessor :current_frequency

  def initialize(input, start_frequency = 0)
    @input = input
    @current_frequency = start_frequency
  end

  def frequency_drift
    input.reduce(current_frequency, :+)
  end

  def calibrate
    frequencies = Set.new([current_frequency])
    i = 0
    loop do
      self.current_frequency += input[i % input.length]
      if frequencies.member?(current_frequency)
        return current_frequency
      else
        frequencies.add(current_frequency)
      end
      i += 1
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).split("\n").map(&:to_i)

puts DeviceCalibration.new(input).frequency_drift
puts DeviceCalibration.new(input).calibrate
