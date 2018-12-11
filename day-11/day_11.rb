class FuelIndicator
  attr_reader :serial_number
  def initialize(serial_number)
    @serial_number = serial_number
  end

  def fuel_level(x, y, size = 1)
    @fuel_level ||= Hash.new do |size_hash, size|
      size_hash[size] = Hash.new do |coord_hash, (x, y)|
        coord_hash[[x, y]] = ((((((x + 10) * y) + serial_number) * (x + 10)) % 1000) / 100) - 5
      end
    end
    @fuel_level[size][[x, y]]
  end

  def total_power((x, y), size)
    total = 0
    (0...size).each do |dx|
      (0...size).each do |dy|
        total += fuel_level(x + dx, y + dy)
      end
    end
    total
  end

  def largest_total_power_block_for_size(size = 3)
    totals = 1.upto(300 - size).each_with_object({}) do |y, totals|
      1.upto(300 - size).each do |x|
        totals[[x, y]] = total_power([x, y], size)
      end
    end
    totals.max_by { |_, v| v }
  end

  def largest_total_power_block
    (1..50)
      .map { |size| p [*largest_total_power_block_for_size(size), size] }
      .max_by { |_, _, size| size }
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.to_i

puts FuelIndicator.new(input).largest_total_power_block_for_size
puts FuelIndicator.new(input).largest_total_power_block
