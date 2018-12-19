class Settlement
  attr_reader :grid
  def initialize(grid)
    @grid = grid
    @xs = (0...grid.first.length)
    @ys = (0...grid.length)
  end

  def self.from_string(str)
    new(str.split("\n").map(&:chars))
  end

  def to_s
    grid.map(&:join).join("\n")
  end

  def tick
    new_grid = grid.map(&:dup)
    grid.each_with_index do |row, y|
      row.each_with_index do |c, x|
        adjacent_values = adjacent_values(x, y)
        case c
        when "."
          c = "|" if adjacent_values.count { |x| x == "|" } >= 3
        when "|"
          c = "#" if adjacent_values.count { |x| x == "#" } >= 3
        when "#"
          c = "." unless adjacent_values.find_index("#") && adjacent_values.find_index("|")
        end
        new_grid[y][x] = c
      end
    end
    @grid = new_grid
  end

  def resource_value
    woods = lumberyards = 0
    grid.each do |row|
      row.each do |c|
        case c
        when "|" then woods += 1
        when "#" then lumberyards += 1
        end
      end
    end

    woods * lumberyards
  end

  def resource_value_after_n_ticks(n)
    grid_hashes = {}
    resource_values = []
    i = 0
    grid_hashes[grid_hash] = i
    resource_values << resource_value
    while i < n
      tick

      gh = grid_hash
      # break if there's a cycle (ie. we've already calculated this state)
      break if grid_hashes[gh]

      i += 1
      grid_hashes[gh] = i
      resource_values << resource_value
    end

    if i == n
      resource_values.last
    else
      cycle_start = grid_hashes[gh]
      cycle_length = resource_values.length - cycle_start
      cycle_offset = (n - cycle_start) % cycle_length
      resource_values[cycle_start + cycle_offset]
    end
  end

  def grid_hash
    to_s.hash
  end

  private

  def adjacent_values(x, y)
    [ [x-1, y-1],
      [x  , y-1],
      [x+1, y-1],
      [x-1,   y],
      [x+1,   y],
      [x-1, y+1],
      [x  , y+1],
      [x+1, y+1] ]
      .select { |x,y| @xs.include?(x) && @ys.include?(y) }
      .map { |x,y| grid[y][x] }
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts Settlement.from_string(input).resource_value_after_n_ticks(10)
puts Settlement.from_string(input).resource_value_after_n_ticks(1_000_000_000)
