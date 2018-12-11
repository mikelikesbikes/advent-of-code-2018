class FuelIndicator
  attr_reader :serial_number
  def initialize(serial_number)
    @serial_number = serial_number
  end

  def fuel_level(x, y, size = 1)
    # memoize the fuel level total for any square of any size on the grid
    @fuel_level ||= Hash.new do |hash, (x, y, size)|
      hash[[x, y, size]] =
        if size == 1
          ((((((x + 10) * y) + serial_number) * (x + 10)) % 1000) / 100) - 5
        elsif size.even?
          lsize = size / 2
          hash[[x,         y,         lsize]] +
          hash[[x,         y + lsize, lsize]] +
          hash[[x + lsize, y,         lsize]] +
          hash[[x + lsize, y + lsize, lsize]]
        elsif size.odd?
          lsize = size / 2
          rsize = size - lsize
          hash[[x,         y,         lsize]] +
          hash[[x,         y + lsize, rsize]] +
          hash[[x + lsize, y,         rsize]] +
          hash[[x + rsize, y + rsize, lsize]] -
          hash[[x + lsize, y + lsize, 1]]
        end
    end
    @fuel_level[[x, y, size]]
  end

  def largest_total_power_block_for_size(size = 3)
    populate_fuel_totals(size)

    @fuel_level
      .select { |(_, _, s), _| s == size }
      .max_by { |_, v| v }
      .first
      .slice(0, 2)
  end

  def largest_total_power_block(lsize=1, rsize=300)
    (10..18).each { |size| populate_fuel_totals(size) }

    @fuel_level
      .max_by { |_, size| size }
      .first
  end

  private

  def populate_fuel_totals(size)
    # memoize which sizes have already been fully populated
    @populated_totals ||= Hash.new do |h, size|
      1.upto(300 - size).each do |y|
        1.upto(300 - size).each do |x|
          fuel_level(x, y, size)
        end
      end
      h[size] = true
    end
    @populated_totals[size]
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.to_i

puts FuelIndicator.new(input).largest_total_power_block_for_size
puts FuelIndicator.new(input).largest_total_power_block
