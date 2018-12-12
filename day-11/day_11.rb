class FuelIndicator
  attr_reader :serial_number, :grid_size

  def initialize(serial_number, grid_size = 300)
    @serial_number = serial_number
    @grid_size = grid_size
  end

  def fuel_level(x, y, size = 1)
    summed_area_table[[x - 1 + size, y - 1 + size]] +
    summed_area_table[[x - 1       , y - 1       ]] -
    summed_area_table[[x - 1 + size, y - 1       ]] -
    summed_area_table[[x - 1       , y - 1 + size]]
  end

  def largest_total_power_block_for_size(size = 3)
    @largest_for_size ||= Hash.new do |h, size|
      max_coord = [-1,-1]
      max_total_power = -2**32
      0.upto(grid_size - size) do |x|
        0.upto(grid_size - size) do |y|
          total_power = fuel_level(x, y, size)
          if total_power > max_total_power
            max_total_power = total_power
            max_coord = [x, y]
          end
        end
      end
      h[size] = [max_coord, max_total_power]
    end
    @largest_for_size[size]
  end

  def largest_total_power_block
    (1..grid_size)
      .lazy
      .map { |size| largest_total_power_block_for_size(size) + [size] }
      .reduce([nil, -2**32, nil, 0]) do |(mcoord, mpower, msize, n), (coord, power, size)|
        break [mcoord, mpower, msize, n] if n > 5
        mpower <= power ? [coord, power, size, 0] : [mcoord, mpower, msize, n + 1]
      end
      .yield_self do |coord, _, size|
        [*coord, size]
      end
  end

  private

  def summed_area_table
    return @summed_area_table if @summed_area_table

    @summed_area_table = Hash.new(0).tap do |table|
      0.upto(grid_size - 1) do |y|
        0.upto(grid_size - 1) do |x|
          table[[x, y]] =
            table[[x - 1, y    ]] +
            table[[x    , y - 1]] -
            table[[x - 1, y - 1]] +
            ((((((x + 10) * y) + serial_number) * (x + 10)) % 1000) / 100) - 5
        end
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.to_i

puts FuelIndicator.new(input).largest_total_power_block_for_size(3).first.join(",")
puts FuelIndicator.new(input).largest_total_power_block.join(",")
