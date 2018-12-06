require "time"

module SpatialAnalyzer

  def safest_area(input)
    input
      .map { |line| parse_coord(line) }
      .yield_self { |coords| [coords, find_bounds(coords)] }
      .yield_self { |coords, bounds| [bounds, fill_grid(bounds, coords)] }
      .yield_self { |bounds, grid| remove_infinites(bounds, grid) }
      .group_by { |_, v| v }
      .map { |_, g| g.length }
      .max
  end

  def nearest_area(input, distance)
    input
      .map { |line| parse_coord(line) }
      .yield_self { |coords| [coords, find_bounds(coords)] }
      .yield_self { |coords, bounds| closer_than(bounds, coords, distance) }
      .length
  end

  def parse_coord(line)
    line
      .split(", ")
      .map(&:to_i)
  end

  def find_bounds((coord, *coords))
    coord
      .zip(*coords)
      .map { |vals| Range.new(*vals.minmax) }
  end

  def dist((ax, ay), (bx, by))
    (ax - bx).abs + (ay - by).abs
  end

  def fill_grid((x_range, y_range), coords)
    y_range.each_with_object({}) do |y, grid|
      x_range.each do |x|
        coords
          .group_by { |coord| dist([x, y], coord) }
          .min_by { |k, _| k }
          .yield_self { |k, v| grid[[x, y]] = v.first if v.length == 1 }
      end
    end
  end

  def remove_infinites(bounds, grid)
    grid
      .each_with_object([]) do |(coord, v), infinites|
        infinites << v if edge?(bounds, coord)
      end
      .yield_self do |infinites|
        grid.reject { |_, coord| infinites.include?(coord) }
      end
  end

  def edge?((x_range, y_range), (x, y))
    x == x_range.begin || x == x_range.end ||
      y == x_range.begin || y == y_range.end
  end

  def closer_than((x_range, y_range), coords, max_distance)
    y_range.reduce([]) do |acc, y|
     x_range.reduce(acc) do |acc, x|
        pos = [x, y]
        if coords.sum { |coord| dist(coord, pos) } < max_distance
          acc << pos
        end
        acc
      end
    end
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.split("\n")

puts SpatialAnalyzer.safest_area(input)
puts SpatialAnalyzer.nearest_area(input, 10000)
