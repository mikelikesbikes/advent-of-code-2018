module FuelIndicator
  def fuel_level(*args)
    @fuel_level ||= Hash.new do |h, k|
      (x, y), serial_number = k
      h[k] = ((((((x + 10) * y) + serial_number) * (x + 10)) % 1000) / 100) - 5
    end
    @fuel_level[args]
  end

  def total_power((x, y), size, serial_number)
    total = 0
    (0...size).each do |dx|
      (0...size).each do |dy|
        total += fuel_level([x + dx, y + dy], serial_number)
      end
    end
    total
  end

  def largest_total_power_block(serial_number, size = 3)
    totals = 1.upto(300 - size).each_with_object({}) do |y, totals|
      1.upto(300 - size).each do |x|
        totals[[x, y]] = total_power([x, y], size, serial_number)
      end
    end
    totals.max_by { |_, v| v }
  end

  def largest_total_power_block_with_size(serial_number)
    (1..50)
      .map { |size| p [*largest_total_power_block(serial_number, size), size] }
      .max_by { |_, _, size| size }
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.to_i

puts FuelIndicator.largest_total_power_block(input)
puts FuelIndicator.largest_total_power_block_with_size(input)
